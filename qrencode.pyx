from new import classobj
from ImageOps import expand
from Image import fromstring


cdef extern from "qrencode.h":
    int QR_ECLEVEL_L
    int QR_ECLEVEL_M
    int QR_ECLEVEL_Q
    int QR_ECLEVEL_H
    
    int QR_MODE_NUM
    int QR_MODE_AN
    int QR_MODE_8
    int QR_MODE_KANJI
    
    struct QRcode:
        int version
        int width
        char *data
    
    QRcode *QRcode_encodeString(char *string, int version, int level, int hint, int casesensitive)


cdef class Encoder:
    def __cinit__(self):
        __sd = lambda x: classobj('', (), x)
        self.mode = __sd(dict(NUMERIC=0, ALNUM=1, BINARY=2, KANJI=3))
        self.eclevel = __sd(dict(L=0, M=1, Q=2, H=3))
        self.width = 400
        self.border = 10
        self.version = 5
        self.case_sensitive = True
    
    def __dealloc__(self):
        pass
    
    def encode(self, char *text, options={}):
        cdef QRcode *_c_code
        cdef int _c_level = QR_ECLEVEL_L
        cdef int _c_hint = QR_MODE_8
        
        border = options.get('border', self.border)
        w = options.get('width', self.width) - border * 2
        v = options.get('version', self.version)
        mode = options.get('mode', self.mode.ALNUM)
        eclevel = options.get('eclevel', self.eclevel.L)
        case_sensitive = options.get('case_sensitive', self.case_sensitive)
        
        p = text
        p = p + '\0'
        _c_code = QRcode_encodeString(p, int(v), _c_level, _c_hint, int(case_sensitive))
        
        version = _c_code.version
        width = _c_code.width
        data = _c_code.data
        
        rawdata = ''
        dotsize = w / width
        realwidth = width * dotsize
        
        for y in range(width):
            line = ''
            for x in range(width):
                if ord(data[y*width+x]) % 2:
                    line += dotsize * chr(0)
                else:
                    line += dotsize * chr(255)
            lines = dotsize * line
            rawdata += lines
        
        image = fromstring('L', (realwidth, realwidth), rawdata)
        
        return expand(image, border, 255)