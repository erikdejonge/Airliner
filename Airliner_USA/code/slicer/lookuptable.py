import os
import pickle

def main():
    l = pickle.load(open("tiles.pickle", "r"))
    for i in l:
        print i

if __name__=="__main__":
    main()