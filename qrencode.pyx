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
        'mode' : QR_MODE_8,
        'ec_level': QR_ECLEVEL_L,
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
        cdef unsigned char *data
        
        options.update(self.default_options)
        
        border = options.get('border')
        w = options.get('width') - border * 2
        v = options.get('version')
        mode = options.get('mode')
        ec_level = options.get('ec_level')
        case_sensitive = options.get('case_sensitive')
       
        # encode the test as a QR code
        str_copy = text
        str_copy = str_copy + '\0'
        _c_code = QRcode_encodeString(str_copy, int(v), int(ec_level), int(mode), int(case_sensitive))
        version = _c_code.version
        width = _c_code.width
        data = _c_code.data
        
        rawdata = ''
        dotsize = w / width
        realwidth = width * dotsize
        
        # build raw image data
        for y in range(width):
            line = ''
            for x in range(width):
                if data[y * width + x] % 2:
                    line += dotsize * chr(0)
                else:
                    line += dotsize * chr(255)
            lines = dotsize * line
            rawdata += lines
        
        # create PIL image w/ border
        image = expand(fromstring('L', (realwidth, realwidth), rawdata), border, 255)
        
        return image
