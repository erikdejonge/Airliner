import csv

def main():
  records = csv.reader(open('Resources/destinations.csv'), delimiter=';')
  c = 0
  s = ""
  targets = []
  lx = []
  ly = []
  for rec in records:
    if len(rec)==0:
      continue

    plist = []
    s = "pointlist = [NSArray arrayWithObjects: "

    if len(rec[2].split(";"))>1:
		    for i in rec[2].split(";"):
				    x = i.split(",")[0]
				    y = i.split(",")[1]      
				    s += "NSStringFromCGPoint(ccp("+x+","+y+")),"		
				    lx.append(x)
				    ly.append(y)            
    else:
        x = rec[2].split(",")[0]
        y = rec[2].split(",")[1]      
        s += "NSStringFromCGPoint(ccp("+x+","+y+")),"
        lx.append(x)
        ly.append(y)
    s+=" nil];\n"
    s += '[ target_data setObject:pointlist forKey:@"'+rec[1]+'"];'
    targets.append(rec[1])
    c += 1    
    #print s
  
  print
  s = "target_names = [[NSArray alloc] initWithObjects:"  
  for t in targets:
    s += '@"'+t+'",'
    
  s += "nil];"
  #print s
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