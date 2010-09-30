from qrencode import Encoder

enc = Encoder()
im = enc.encode('http://bit.ly')
im.save('out.png')
