#! /usr/bin/env python

import os
import xml.etree.ElementTree as ET
from nexus import *

settings(
        pseudo_dir = '/work/04843/aannabe/stampede2/docs/accurate/qpack/pseudopotentials',
        runs = '.',
        results = '.',
        sleep = 30,
        generate_only = False,
        status_only = False,
        machine = 'ws64')


#OPTIMIZATION methods
linopt1 = linear(
    energy               = 0.0,
    unreweightedvariance = 1.0,
    reweightedvariance   = 0.0,
    samples              = 131072, #1000000,
    substeps             = 20,
    steps                = 1,
    blocks               = 50,
    nonlocalpp           = True,
    usebuffer            = True,
    usedrift             = False,
    minmethod            = 'OneShiftOnly',
    beta                 = 0.0,
    exp0                 = -15,
    bigchange            = 20.0,
    minwalkers           = 0.3,
    alloweddifference    = 1e-5,
    stepsize             = 0.2,
    timestep             = 0.5,
    stabilizerscale      = 2.0,
    nstabilizers         = 3
    )

linopt2 = linopt1.copy()
linopt2.unreweightedvariance = 0.0
linopt2.reweightedvariance = 0.05
linopt2.energy = 0.95
linopt2.samples = linopt1.samples*4
linopt3 = linopt2.copy()
linopt3.samples = linopt2.samples*4


structure = read_structure('Fe.xyz')

atom = generate_physical_system(
    structure       = structure,
    net_charge      = 0,
    net_spin        = 4,
    Fe               = 16 
    )

sims = []

Fe = generate_convert4qmc(
        qp='../Fe.dump',
        identifier = 'Fe',
        prefix = 'Fe',
        path='qz_Fe',
        job=job(cores=1),
        production=True,
        no_jastrow=True,
        threshold=1e-20
        )
sims.append(Fe)

optJ12 = generate_qmcpack(
        identifier = 'optJ12',
        path = 'qz_optJ12',
        system = atom,
        pseudos = ['Fe.ccECP.xml'],
        job = job(nodes=2,processes=2,processes_per_node=1,threads=32),
        #job = job(cores=8,hours=1,queue='skx-normal'),
        bconds = 'nnn',
        input_type = 'basic',
        jastrows = [('J1','bspline',8,5),
                    ('J2','bspline',8,10)],
        calculations = [loop(max=2,qmc=linopt1),
                loop(max=0,qmc=linopt2),
                loop(max=0,qmc=linopt3)],
        dependencies = [(Fe,'orbitals')]
        )
#sims.append(optJ12)

optJ123 = generate_qmcpack(
        identifier = 'optJ123',
        path = 'qz_optJ123',
        #job = qmc_real_job,
        job = job(nodes=2,processes=2,processes_per_node=1,threads=32),
        pseudos = ['Fe.ccECP.xml'],
        system = atom,
        bconds = 'nnn',
        input_type = 'basic',
        jastrows = [('J1','bspline',8,5),
                    ('J2','bspline',8,10),
                    ('J3','polynomial',3,3,3)],
        calculations = [loop(max=1,qmc=linopt1),
                       loop(max=2,qmc=linopt2),
                        loop(max=0,qmc=linopt3)],
        dependencies = [(Fe,'orbitals'),(optJ12,'jastrow')]
        )
#sims.append(optJ123)

qmc_noj = generate_qmcpack(
    identifier = 'qmc_noj',
    path = 'qz_qmc_noj',
        #job = qmc_real_job,
        #job = job(nodes=2,processes=2,processes_per_node=1,threads=32),
        job = job(nodes=1,cores=64),
    pseudos = ['Fe.ccECP.xml'],
    system = atom,
    bconds = 'nnn',
    input_type = 'basic',
    jastrows = [],
    calculations = [vmc(walkers = 2,
                        substeps = 5,
                        steps = 50,
                        blocks = 50,
                        usedrift = False,
                        timestep = 0.12),
                    #dmc(walkers = 1024,
                    #    timestep = 0.02,
                    #    blocks = 60,
                    #    steps = 50,
                    #    nonlocalmoves = True),
                    #dmc(walkers = 1024,
                    #    timestep = 0.01,
                    #    blocks = 60,
                    #    steps = 100,
                    #    nonlocalmoves = True),
                    #dmc(walkers = 1024,
                    #    timestep = 0.005,
                    #    blocks = 60,
                    #    steps = 200,
                    #    nonlocalmoves = True),
                        ],
    dependencies = [(Fe,'orbitals')]
    )
sims.append(qmc_noj)

qmc = generate_qmcpack(
    identifier = 'qmc',
    path = 'qz_qmc',
        #job = qmc_real_job,
        #job = job(nodes=2,processes=2,processes_per_node=1,threads=32),
        job = job(nodes=1,cores=64),
    pseudos = ['Fe.ccECP.xml'],
    system = atom,
    bconds = 'nnn',
    input_type = 'basic',
    jastrows = [],
    calculations = [vmc(walkers = 1024,
                        substeps = 50,
                        steps = 50,
                        blocks = 50,
                        usedrift = False,
                        timestep = 1.00),
                    dmc(walkers = 1024,
                        timestep = 0.02,
                        blocks = 60,
                        steps = 50,
                        nonlocalmoves = True),
                    dmc(walkers = 1024,
                        timestep = 0.01,
                        blocks = 60,
                        steps = 100,
                        nonlocalmoves = True),
                    dmc(walkers = 1024,
                        timestep = 0.005,
                        blocks = 60,
                        steps = 200,
                        nonlocalmoves = True),
                        ],
    dependencies = [(Fe,'orbitals'),(optJ123,'jastrow')]
    )
#sims.append(qmc)

run_project(sims)
