
import os
import base64
import zlib
from struct import *
import sys
import os
import getopt
import xml.dom.minidom
import base64
import gzip
from cStringIO import StringIO


def decompress_data(data):
   """Decompresses a string of gzipped layer data."""
   data_buffer = StringIO(data)
   gzip_file = gzip.GzipFile('', 'rb', 9, data_buffer)
   data = gzip_file.read()
   gzip_file.close()
   data_buffer.close()
   return data
   
def main():
    s = "H4sIAAAAAAAAABXXAxIgBgADwLNt27Zt27Ztuz3btm3btm3b7nYm+4YkAQMECBCIwAQhKMEITghCEorQhCEs4QhPBCISichEISrRiE4MYhKL2MQhLvGITwISkojEJCEpyUhOClKSitSkIS3pSE8GMpKJzGQhK9nITg5ykovc5CEv+chPAQpSiMIUoSjFKE4JSlKK0pShLOUoTwUqUonKVKEq1ahODWpSi9rUoS71qE8DGtKIxjShKc1oTgta0orWtKEt7WhPBzrSic50oSvd6E4PetKL3vShL/3ozwAGMojBDOEf/mUowxjOCEYyitGMYSzjGM8EJjKJyUxhKtOYzgxmMovZzGEu85jPAhayiMUsYSnLWM4KVrKK1axhLetYzwY2sonNbGEr29jODnayi93sYS/72M8BDnKIwxzhKMc4zglOcorTnOEs5zjPBS5yictc4SrXuM4NbnKL29zhLve4zwMe8ojHPOEpz3jOC17yite84S3veM8HPvKJz3zhK9/4zg9+8ovf/OEvAQIKgQhMEIISjOCEICShCE0YwhKO8EQgIpGITBSiEo3oxCAmsYhNHOISj/gkICGJSEwSkpKM5KQgJalITRrSko70ZCAjmchMFrKSjezkICe5yE0e8pKP/BSgIIUoTBGKUozilKAkpShNGcpSjvJUoCKVqEwVqlKN6tSgJrWoTR3qUo/6NKAhjWhME5rSjOa0oCWtaE0b2tKO9nSgI53oTBe60o3u9KAnvehNH/rSj/4MYCCDGMwQ/uFfhjKM4YxgJKMYzRjGMo7xTGAik5jMFKYyjenMYCazmM0c5jKP+SxgIYtYzBKWsozlrGAlq1jNGtayjvVsYCOb2MwWtrKN7exgJ7vYzR72so/9HOAghzjMEY5yjOOc4CSnOM0ZznKO81zgIpe4zBWuco3r3OAmt7jNHe5yj/s84CGPeMwTnvKM57zgJa94zRve8o73fOAjn/jMF77yje/84Ce/+M0f/vJ/8QckEIEJQlCCEZwQhCQUoQlDWMIRnghEJBKRiUJUohGdGMQkFrGJQ1ziEZ8EJCQRiUlCUpKRnBSkJBWpSUNa0pGeDGQkE5nJQlaykZ0c5CQXuclDXvKRnwIUpBCFKUJRilGcEpSkFKUpQ1nKUZ4KVKQSlalCVapRnRrUpBa1qUNd6lGfBjSkEY1pQlOa0ZwWtKQVrWlDW9rRng50pBOd6UJXutGdHvSkF73pQ1/60Z8BDGQQgxnCP/zLUIYxnBGMZBSjGcNYxjGeCUxkEpOZwlSmMZ0ZzGQWs5nDXOYxnwUsZBGLWcJSlrGcFaxkFatZw1rWsZ4NbGQTm9nCVraxnR3sZBe72cNe9rGfAxzkEIc5wlGOcZwTnOQUpznDWc5xngtc5BKXucJVrnGdG9zkFre5w13ucZ8HPOQRj3nCU57xnBe85BWvecNb3vGeD3zkE5/5wle+8Z0f/OQXv/nDX/4f/QEJRGCCEJRgBCcEIQlFaMIQlnCEJwIRiURkohCVaEQnBjGJRWziEJd4xCcBCUlEYpKQlGQkJwUpSUVq0pCWdKQnAxnJRGaykJVsZCcHOclFbvKQl3zkpwAFKURhilCUYhSnBCUpRWnKUJZylKcCFalEZapQlWpUpwY1qUVt6lCXetSnAQ1pRGOa0JRmNKcFLWlFa9rQlna0pwMd6URnutCVbnSnBz3pRW/60Jd+9GcAAxnEYIbwD/8ylGEMZwQjGcVoxjCWcYxnAhOZxGSmMJVpTGcGM5nFbOYwl3nMZwELWcRilrCUZSxnBStZxWrWsJZ1rGcDG9nEZrawlW1sZwc72cVu9rCXfeznAAc5xGGOcJRjHOcEJznFac5wlnOc5wIXucRlrnCVa1znBje5xW3ucJd73OcBD3nEY57wlGc85wUvecVr3vCWd7znAx/5xGe+8JVvfOcHP/nFb/7wl/8P/39V7dsQABAAAA=="
    
    tilesrangex = 8192/32
    tilesrangey = 4096/32    
    tr = tilesrangex*tilesrangey
    print tilesrangex, tilesrangey, tr, 32*32
    
    s = ''
    for i in range(0,2048):
        if i<1024-1:
            print i+1
            s += pack("<l", i+1)
        else:
            s += pack("<l", 0)
    print base64.b64encode(zlib.compress(s))
    s = ''
    for i in range(0,2048):
        if i>1024-1:
            s += pack("<l", i+1)
        else:
            s += pack("<l", 0)    
    print base64.b64encode(zlib.compress(s))
    
if __name__=="__main__":
    main()