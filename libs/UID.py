# Thanks to Nitrus#1839 for making this cool script.

import argparse, binascii, struct, warnings
import sklykeys

blankPath = ''
skyPath = ''
outputFileName = ''

if __name__ == '__main__':
    parser = argparse.ArgumentParser()
    required = parser.add_argument_group('required arguments')
    required.add_argument('-b', '--blank', help="The blank tag dump", required=True)
    required.add_argument('-s', '--sky', help="The Skylander dump you want to write", required=True)
    required.add_argument('-n', '--name', help="The name of your new dump", required=True)
    args = parser.parse_args()
    blankPath = args.blank
    skyPath = args.sky
    outputFileName = args.name

def calculate_bcc(bcc):
    return (bcc[0] ^ bcc[1] ^ bcc[2] ^ bcc[3])

def check_keys(a_or_b, data):
    blockOffset = 0x0
    if a_or_b == 'b':
        blockOffset = 0x0A
    data.seek(0)
    verified=True
    for sector in range(0, 16):
        data.seek(0x30, 1)
        data.seek(blockOffset, 1)
        key = binascii.hexlify(data.read(0x06)).decode("utf-8")
        data.seek(0xA - blockOffset,1)
        verified = verified | (key == "000000000000" or key.upper() == "FFFFFFFFFFFF")
    return verified

# Load the blank tag dump
cleanTag = open(blankPath,'rb')

# Load the Skylander dump
skylanderDump = open(skyPath,'rb')

# Check if A and B keys are standard
verifyKeysA = check_keys('a', cleanTag)
verifyKeysB = check_keys('b', cleanTag)

if (verifyKeysA == False or verifyKeysB == False):
    warnings.warn("Some of the keys in the blank dump are not standard!")

# Reset seek position to the beginning of the file
cleanTag.seek(0)

bytesUid = cleanTag.read(0x04)
writtenBcc = cleanTag.read(0x01)
hexWrittenBcc = binascii.hexlify(writtenBcc)
sak = cleanTag.read(0x01)
atqa = cleanTag.read(0x02)

hexUid = binascii.hexlify(bytesUid)
stringUid = hexUid.decode("utf-8")

print("UID:",   "0x" + stringUid.upper())
print("BCC:",   "0x" + hexWrittenBcc.decode("utf-8").upper())
print("SAK:",   "0x" + binascii.hexlify(sak).decode("utf-8").upper())
print("ATQA:",  "0x" + binascii.hexlify(struct.pack('<H',int.from_bytes(atqa, "big"))).decode("utf-8").upper())

calculatedBcc = calculate_bcc(bytesUid)
bccIsGood = calculatedBcc == int(hexWrittenBcc,16)
if (bccIsGood == False):
    warnings.warn("This Tag's BCC is incorrect! Possibly a 7 byte UID?")

cleanTag.seek(0)
lockedZeroBlock = cleanTag.read(0x10)
cleanTag.close()
# At this point, we're done with operations regarding the blank tag

skylanderDump.seek(0)
newFile = open(outputFileName + ".dump", "wb")

# Prime the new file with the entire Skylander dump
newFile.write(skylanderDump.read(1024))

# Write the blank tag's manufacturer block to the new file
newFile.seek(0)
newFile.write(lockedZeroBlock)

skylanderDump.seek(0x10)
skylanderInfo = skylanderDump.read(0x0E)
skylanderDump.close()
zeroChecksumData = (lockedZeroBlock + skylanderInfo)

# Write the type 0 checksum for the new data
binaryCrc16 = int.to_bytes(struct.unpack("<H", struct.pack(">H", binascii.crc_hqx(zeroChecksumData, 0xFFFF)))[0], 2, "big")
newFile.seek(0x0E, 1)
newFile.write(binaryCrc16)

# Generate new keys for the blank tag's UID
keys = sklykeys.generate_keys(stringUid)

print("New keys:", keys)

# Set new keys
newFile.seek(0)
for i in range(0, 16):
    newFile.seek(0x30, 1)
    newFile.write(binascii.unhexlify(keys[i]))
    newFile.seek(0xA, 1)

# Unlock zero sector
newFile.seek(0x36)
newFile.write(binascii.unhexlify("FF0780"))

# Done
newFile.close()
