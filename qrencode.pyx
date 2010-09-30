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
    
    ctypedef struct QRcode:
        int version
        int width
        unsigned char *data
    
    QRcode *QRcode_encodeString(char *string, int version, int level, int hint, int casesensitive)


cdef class Encoder:
    default_options = {
        'mode' : QR_MODE_AN,
        'eclevel': QR_ECLEVEL_L,
        'width': 400,
        'border': 10,
        'version': 5,
        'case_sensitive': True
    }
    
    def __cinit__(self):
        pass
    
    def __dealloc__(self):
        pass
    
    def encode(self, char *text, options={}):
        cdef QRcode *_c_code
        cdef int _c_level = QR_ECLEVEL_L
        cdef int _c_hint = QR_MODE_8
        cdef unsigned char *data
        
        options.update(self.default_options)
        
        border = options.get('border')
        w = options.get('width') - border * 2
        v = options.get('version')
        mode = options.get('mode')
        eclevel = options.get('eclevel')
        case_sensitive = options.get('case_sensitive')
        
        str_copy = text
        str_copy = str_copy + '\0'
        _c_code = QRcode_encodeString(str_copy, int(v), _c_level, _c_hint, int(case_sensitive))
        
        version = _c_code.version
        width = _c_code.width
        data = _c_code.data
        
        rawdata = ''
        dotsize = w / width
        realwidth = width * dotsize
        
        for y in range(width):
            line = ''
            for x in range(width):
                if data[y*width+x] % 2:
                    line += dotsize * chr(0)
                else:
                    line += dotsize * chr(255)
            lines = dotsize * line
            rawdata += lines
        
        image = fromstring('L', (realwidth, realwidth), rawdata)
        
        return expand(image, border, 255)