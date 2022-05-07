#!/usr/bin/python3
# a cli interface for nfctoys libraries
# requires tnp3xxx.py from nfc.toys at:
# https://github.com/nfctoys/nfctoys
#
# Thanks to Toni Cunyat(elbuit) for making this cli.
# This software was coded by Toni Cunyat in 2021
# This software is for educational purposes.
# sklykeys.py creates a file that include the keys
# from your skylander copy.
#



import getopt, sys, binascii
import tnp3xxx
argv = sys.argv[1:]


file=None
to_file=None
uid=None
output_format='eml' # binary, eml or m5c (mfrc522cli)

def generate_keys(uid):
    keysa = []
    for sector in range(0, 16):
        keysa.append(tnp3xxx.calc_keya(uid, sector))
    return keysa

def get_bin_file(filename):
    with open(filename, 'rb') as f:
        content = f.read()
        f.close()
    return content

def write_file(filename,data):
    write_format='wb+' if output_format =="binary" else 'w+'

    with open(filename, write_format) as f:
        f.write(data)
        f.close()

def get_sectors_ascii(filename):
    content=get_bin_file(filename)
    hexcontent = binascii.hexlify(content).decode("utf-8")
    n = 32
    chunks = [hexcontent[i:i+n] for i in range(0, len(hexcontent), n)]
    return chunks
def get_uid_from_file(filename):
    chunks = get_sectors_ascii(filename)
    return chunks[0][:8]

def get_data_mfrc522_format(data):
    i = 0
    for field in data:
        data[i] = "lb "+str(i)+" "+field
        i = i + 1
    data = "\n".join(data)
    return data

def get_keys_mfrc522_format(keys):
    for sector in range(0, 16):
        keys[sector]='lka '+str(sector)+" "+keys[sector]
    return keys

def generate_signed_ascii(filename):
    chunks=get_sectors_ascii(filename)
    uid=get_uid_from_file(filename)
    keys=generate_keys(uid)
    key=0
    for i in range(0,16):
        sector=4*i+3
        chunks[sector]=keys[i] + chunks[sector][12:]
    return chunks

def print_help():
    print("\nsklykeys.py a cli interface for tnp3xxx.py library from nfc.toys \n"
          "that allows us to read a copy in binary mode "
          "and write in eml format , binary format or mfrc522cli format\n"
          "  -h prints this help\n"
          "  -u uid (6 bytes in hex) prints keys in stdout\n"
          "  -f file read from file (in binary mode)\n"
          "  -t file write to file otherwise to stdout\n"
          "  -o output format binary, eml or m5c (mfrc522cli) format. Default Proxmark emulator format (EML)\n\n"
          "example: ./sklykeys.py -f spiro.bin -t spiro_keys.m5c -o m5c"
          "\n"
          )


if __name__ == '__main__':

    try:
        opts, args = getopt.getopt(argv, 'ho:u:f:t:',)

    except getopt.GetoptError:

        print('\n\nERROR: Wrong parameters\n\n')
        print_help()
        sys.exit(2)

    for opt,arg in opts:
        if opt in ['-u']:
            uid=arg

        if opt in ['-h']:
            print_help()

        if opt in ['-f']:
            file=arg

        if opt in ['-t']:            
            to_file=arg

        if opt in ['-o']:
            output_format=arg

        

    if uid is not None:
        keys=generate_keys(uid)
        if output_format == 'm5c':
            keys=get_keys_mfrc522_format(keys)
        print("\n".join(keys))

    elif file is not None:

        data=generate_signed_ascii(file)

        if output_format == 'eml':
            data = "\n".join(data)

        elif output_format == 'm5c':
            data=get_data_mfrc522_format(data)

        else:
            data="".join(data)
            data=binascii.unhexlify(data)
            data=bytearray(data)

        if to_file is not None:
            write_file(to_file,data)

        else:
            print(data)
    else:
        print_help()