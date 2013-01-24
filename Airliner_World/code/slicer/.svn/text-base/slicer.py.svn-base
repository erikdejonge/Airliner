import os
import Image
import pickle

def make_blocks(wp, hp):
    l = []
    num_width_points = len(wp)
    num_height_points = len(hp)
    c = 0
    
    for nhp in range(0, num_height_points-1):
        for nwp in range(0, num_width_points-1):            
            t = (wp[nwp], hp[nhp], wp[nwp+1], hp[nhp+1])
            l.append(t)
    return l            
    
    
def main():
    os.system("rm ./tiles/s*.png")
    im = Image.open("world.png")
    slicesize = 1024
    ws = 0    
    width = im.size[0]
    height = im.size[1]
    print "w:", width, "h:", height
    testformod=False
    if testformod: 
        if 0!=width%slicesize:
            print "width:", width," not dividable by", slicesize
            bwidth = width
            while 0!=width%slicesize:
                width += 1
            print "try width =", width
            width = bwidth
            while 0!=width%slicesize:
                width -= 1
            print "try width =", width            
            return
        if 0!=height%slicesize:
            bheigh=height
            print "height:", height," not dividable by", slicesize
            while 0!=height%slicesize:
                height += 1
            print "try height =", height
            height=bheigh
            while 0!=height%slicesize:
                height -= 1
            print "try height =", height            
            return

    wpoints = [0]
    while ws<width:
        ep = ws + slicesize
        if ep>width:
            ep = width
        wpoints.append( ep )
        ws += slicesize   
    
    hpoints = [0]    
    hs = 0    
    ep = 0
    while hs<height:
        ep = hs + slicesize
        if ep>height:
            ep=height
        hpoints.append ( ep )
        hs += slicesize
        
    print im.size
    c = 0
    blocks = make_blocks(wpoints, hpoints)
    l = []
    for box in blocks:
        region = im.crop(box)
        fname = "./tiles/s"+str(c)+".png"
        d = {}
        d["name"]=fname
        d["x"]=box[0]
        d["y"]=box[1]
        d["x1"]=box[2]
        d["y1"]=box[2]
        print d                
        l.append(d)           
        region.save(fname)
        c+=1
    pickle.dump(l, open("tiles.pickle", "w"))
    
if __name__=="__main__":
    main()