import os

l = os.listdir('.')
for i in l:
  if "menu-" in str(i):
    print '[[CCTextureCache sharedTextureCache] addImage:@"'+str(i)+'"];'
