import csv

def main():
  records = csv.reader(open('Resources/destinations.csv'), delimiter=';')
  c = 0
  s = ""
  lx = []
  ly = []  
  for rec in records:
    if len(rec)==0:
      continue
    f = True
    plist = []
    for i in rec:
      if not f:
        if len(i.strip())!=0:
          plist.append(i)
      f = False
    #s = "pointlist = [NSArray arrayWithObjects: "
    x = -1
    y = -1
    f = True
    for i in plist:
      x = i.split(",")[0]
      y = i.split(",")[1]      
      if f:
        lx.append(x)
        ly.append(y)            
        f = False      
      #s += "NSStringFromCGPoint(ccp("+x+","+y+")),"
    #s+=" nil];\n"
    #s += '[ target_data setObject:pointlist forKey:@"'+rec[0]+'"];'
    s += "@\""+rec[0]+"\", "
    print c, rec[0]
    c += 1
    #print 
  #print s
  
  print "itemcount:", c
  s = ""
  for x in lx:
    s += '@"'+str(x)+'"'+","
  print s
  s = ""
  for y in ly:
    s += '@"'+str(y)+'"'+","  
  print s

if __name__=="__main__":
  main()