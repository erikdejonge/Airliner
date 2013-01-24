import csv

def main():
  records = csv.reader(open('Resources/destinations.csv'), delimiter=';')
  c = 0
  s = ""
  for rec in records:
    if len(rec)==0:
      continue
    c += 1
    f = True
    plist = []
    for i in rec:
      if not f:
        if len(i.strip())!=0:
          plist.append(i)
      f = False
    #s = "pointlist = [NSArray arrayWithObjects: "
    for i in plist:
      x = i.split(",")[0]
      y = i.split(",")[1]      
      #s += "NSStringFromCGPoint(ccp("+x+","+y+")),"
    #s+=" nil];\n"
    #s += '[ target_data setObject:pointlist forKey:@"'+rec[0]+'"];'
    s += "@\""+rec[0]+"\", "
    #print 
  print s
  print "itemcount:", c

if __name__=="__main__":
  main()