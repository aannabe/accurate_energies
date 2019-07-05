#! /usr/bin/env python

import os
from nexus import *

settings(
        pseudo_dir = '/work/04843/aannabe/stampede2/docs/accurate/qpack/pseudopotentials',
        runs = '.',
        results = '.',
        sleep = 10,
        generate_only = True,
        status_only = False,
        machine = 'stampede2',
        account = '')

if settings.machine == 'stampede2':
    qmc_presub = '''
module load hdf5
module load cmake
module load fftw3
module load boost
'''
    qmcpack_real = '/work/04843/aannabe/stampede2/codes/qmcpack/build_soa/bin/qmcpack'
    atomx_real = 'convert4qmc'
    qmc_job_inp = obj(threads=16,user_env=False,presub=qmc_presub)
    atomx_job_inp = obj(user_env=False,presub=qmc_presub)
    qmc_real_job = job(nodes=16,processes_per_node=2,hours=2,app=qmcpack_real,queue='development',**qmc_job_inp)
    atomx_real_job = job(serial=True,hours=1,app=atomx_real,queue='skx-dev',**atomx_job_inp)


#OPTIMIZATION methods
linopt1 = linear(
    energy               = 0.0,
    unreweightedvariance = 1.0,
    reweightedvariance   = 0.0,
    samples              = 4000,
    substeps             = 5,
#    steps                = 1,
    blocks               = 50,
#    nonlocalpp           = True,
#    usebuffer            = True,
#    usedrift             = False,
    minmethod            = 'OneShiftOnly',
#    beta                 = 0.0,
#    exp0                 = -15,
#    bigchange            = 20.0,
#    minwalkers           = 0.3,
#    alloweddifference    = 1e-5,
#    stepsize             = 0.2,
    timestep             = 0.1,
#    stabilizerscale      = 2.0,
#    nstabilizers         = 3
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
    Fe              = 16 
    )

sims = []

atomx = generate_convert4qmc(
        qp='/work/04843/aannabe/stampede2/docs/accurate/qpack/Fe/gamess_attempt/QZ/check_jast/Fe.dump',
        identifier = 'atomx',
        prefix = 'atomx',
        path='5z_atomx',
        job=atomx_real_job,
        production=True,
        no_jastrow=False,
        threshold=1e-20,
        hdf5=False
        )
sims.append(atomx)

optJ12 = generate_qmcpack(
        identifier = 'optJ12',
        path = '5z_optJ12',
        system = atom,
        pseudos = ['Fe.ccECP.xml'],
        job = qmc_real_job,
        bconds = 'nnn',
        input_type = 'basic',
        jastrows = [('J1','bspline',8,5),
                    ('J2','bspline',8,10)],
        calculations = [loop(max=1,qmc=linopt1),
                loop(max=1,qmc=linopt2),
                loop(max=0,qmc=linopt3)],
        dependencies = [(atomx,'orbitals')]
        )
sims.append(optJ12)

optJ123 = generate_qmcpack(
        identifier = 'optJ123',
        path = '5z_optJ123',
        job = qmc_real_job,
        pseudos = ['Fe.ccECP.xml'],
        system = atom,
        bconds = 'nnn',
        input_type = 'basic',
        jastrows = [('J1','bspline',8,5),
                    ('J2','bspline',8,10),
                    ('J3','polynomial',3,3,3)],
        calculations = [loop(max=1,qmc=linopt1),
                       loop(max=1,qmc=linopt2),
                        loop(max=0,qmc=linopt3)],
        dependencies = [(atomx,'orbitals'),(optJ12,'jastrow')]
        )
sims.append(optJ123)


#qmc_noj = generate_qmcpack(
#    identifier = 'qmc_noj',
#    path = '5z_qmc_noj',
#        job = qmc_real_job,
#    pseudos = ['Fe.ccECP.xml'],
#    system = atom,
#    bconds = 'nnn',
#    input_type = 'basic',
#    jastrows = [],
#    calculations = [vmc(walkers = 1,
#                        substeps = 5,
#                        steps = 50,
#                        blocks = 50,
#                        usedrift = False,
#                        timestep = 0.12),
#                    dmc(walkers = 1024,
#                        timestep = 0.02,
#                        blocks = 60,
#                        steps = 50,
#                        nonlocalmoves = True),
#                    dmc(walkers = 1024,
#                        timestep = 0.01,
#                        blocks = 60,
#                        steps = 100,
#                        nonlocalmoves = True),
#                    dmc(walkers = 1024,
#                        timestep = 0.005,
#                        blocks = 60,
#                        steps = 200,
#                        nonlocalmoves = True),
#                        ],
#    dependencies = [(atomx,'orbitals')]
#    )
#sims.append(qmc_noj)

qmc = generate_qmcpack(
    identifier = 'qmc',
    path = '5z_qmc',
        job = qmc_real_job,
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
    dependencies = [(atomx,'orbitals'),(optJ123,'jastrow')]
    )
sims.append(qmc)

run_project(sims)
