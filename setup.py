import sys

from distutils.core import setup
from distutils.extension import Extension

from optparse import OptionParser


version = '0.2'

parser = OptionParser()
parser.add_option("", "--regenerate", action='store_true', dest='cython',
                  help='regenerate C source via Cython (requires Cython > 0.13)')
(options, args) = parser.parse_args()

# remove our options from argv to distutils doesn't barf
for i, a in enumerate(sys.argv):
    if a == '--regenerate':
        sys.argv.pop(i)

cmdclass = {}
source_files = ['qrencode.c']
if options.cython:
    from Cython.Distutils import build_ext
    cmdclass = { 'build_ext': build_ext }
    source_files = ['qrencode.pyx']

setup(
    name="pyqrencode",
    version="0.2",
    description="Python bindings for libqrencode",
    author="Matt Reiferson",
    author_email="mattr@bit.ly",
    url="http://github.com/bitly/pyqrencode",
    download_url="http://github.com/downloads/bitly/pyqrencode/pyqrencode-%s.tar.gz" % version,
    cmdclass=cmdclass,
    ext_modules=[Extension("qrencode", source_files, libraries=["qrencode"])]
)
