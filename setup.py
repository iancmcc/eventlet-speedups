from setuptools import setup, find_packages
from distutils.core import Extension
import os

version = '0.9.17'

long_description = (open('README.txt').read())


def extensions():
    root = os.path.join(os.path.dirname(__file__), 'src')
    for dpath, dnames, fnames in os.walk(root):
        fqdn = '.'.join(dpath.replace(root, '').lstrip('/').split('/'))
        for fname in fnames:
            if fname.endswith('.c'):
                yield Extension('%s.%s' % (fqdn, fname[:-2]), 
                        ['%s/%s' % (dpath, fname)])



setup(name='eventlet.speedups',
      version=version,
      description="Cython versions of eventlet modules",
      long_description=long_description,
      classifiers=[
        "Programming Language :: Python",
        ],
      keywords='',
      author='Ian McCracken',
      author_email='ian.mccracken@gmail.com',
      url='http://github.com/iancmcc/eventlet-speedups',
      license='MIT',
      packages=find_packages('src'),
      package_dir = {'': 'src'},
      namespace_packages=['eventlet'],
      include_package_data=True,
      zip_safe=False,
      install_requires=['eventlet==%s' % version],
      ext_modules=list(extensions())
      )
