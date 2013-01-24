import os

l = os.listdir('.')
for i in l:
  if "cloud" in str(i):
    print '@"'+str(i)+'",'
