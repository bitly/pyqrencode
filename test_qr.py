from qrencode import Encoder

enc = Encoder()
im = enc.encode('http://bit.ly', { 'width': 100 })
im.save('out.png')
