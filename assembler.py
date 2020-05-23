import sys


PATH = ''
instMemPath="/processor/Fetch_Stage/I_mem/im_RAM"
dataMemPath="/processor/MEMORY_STAGE/datamem/dm_RAM"

try:
    PATH = sys.argv[1]
except:
    print('Error In Path Name')
    sys.exit(1)


instDict = {"NOP": "000000", "SETC": "000001", "CLRC": "000010", "NOT": "000011", "INC": "000100", "DEC": "000101",
            "OUT": "000110", "IN": "000111", "SWAP": "001000", "ADD": "001001", "IADD": "101010", "SUB": "001011",
            "AND": "001100", "OR": "001101", "SHL": "101110", "SHR": "101111", "PUSH": "010000", "POP": "010001",
            "LDM": "110010", "LDD": "110011", "STD": "110100", "JZ": "011000", "JN": "011001", "JC": "011010",
            "JMP": "011011", "CALL": "011100", "RET": "011101", "RTI": "011110"}

noSource = []
thirtyTwo = ['IADD', 'SHL', 'SHR', 'LDM', 'LDD', 'STD']
noSource = ['NOP', 'SETC', 'CLRC', 'RET', 'RTI','SWAP']
anotherSrc = ['ADD', 'SUB', 'AND', 'OR']

def fill_ram_mem(bits, idx,path):
    f.write("mem load -filltype value -filldata %s -fillradix symbolic %s/ram(%d)\n"
            % (bits,path,idx))

f = open(PATH, 'r')
lines = [word.strip() for word in f.readlines()]
f.close()
commands = [[]]
commands = [line.split("#") for line in lines]
commands = [sub[0] for sub in commands if sub[0] != '']
commands = [sub.strip() for sub in commands]
commands = [cmd.upper() for cmd in commands]
fidx = commands.index('.ORG 0')
config = commands[fidx:fidx + 4]
instr = commands[fidx + 4:]
instList = [inst.split(',')[0].split(' ') + inst.split(',')[1:] for inst in instr]
parsedInstList = [list(filter(None, lis)) for lis in instList]
# configuration for the data memory
dataMem = {}
dataMem[config[0].split(' ')[-1]] = config[1]
dataMem[config[2].split(' ')[-1]] = config[3]


f = open(PATH.replace('.asm', '.do'), 'w')

for i,(key,value) in enumerate(dataMem.items()):
    value32=bin(int(value,16))[2:].zfill(32)
    fill_ram_mem(value32[0:16],int(key),dataMemPath)
    fill_ram_mem(value32[16:32],int(key)+1,dataMemPath)


def parseInst(lst, fillFrom):
    s = instDict[lst[0]]
    if (lst[0] not in noSource and lst[0] not in thirtyTwo or lst[0]=='SWAP'):
        s = s + bin(int(lst[-1][-1]))[2:].zfill(3)
    if(lst[0] in thirtyTwo):
        s = s + bin(int(lst[-2][-1]))[2:].zfill(3)
    if (lst[0] in anotherSrc and lst[0]!='SUB'):
        s += bin(int(lst[2][-1]))[2:].zfill(3)
        s += bin(int(lst[1][-1]))[2:].zfill(3)
    if(lst[0] =='SUB'):
        s += bin(int(lst[1][-1]))[2:].zfill(3)
        s += bin(int(lst[2][-1]))[2:].zfill(3)
    if (lst[0] == 'IADD'):
        s += bin(int(lst[1][-1]))[2:].zfill(3)
    if (lst[0] in ['SWAP', 'LDD', 'STD']):
        s = s + '000'
    if (lst[0] == 'SWAP'):
        s += bin(int(lst[1][-1]))[2:].zfill(3)
    if (lst[0] in ['LDD', 'STD']):
        s =  s + bin(int(lst[2], 16))[2:].zfill(16)[0:4]
        s= s.ljust(16,'0')+'0000'+bin(int(lst[2], 16))[2:].zfill(16)[4:16]
    if (lst[0] in ['SHL', 'SHR', 'LDM','IADD']):
        s=s.ljust(16,'0')
        s = s+bin(int(lst[-1], 16))[2:].zfill(16);
    if (lst[0] in thirtyTwo):
        fill_ram_mem(s[0:16].ljust(16,'0'), fillFrom,instMemPath)
        fill_ram_mem(s[16:32].ljust(16,'0'), fillFrom+1,instMemPath)
    else:
        fill_ram_mem(s.ljust(16,'0'), fillFrom,instMemPath)



fillFrom = 0
i = 0;
while (i < len(parsedInstList)):
    print(parsedInstList[i])
    if (parsedInstList[i][0] == '.ORG'):
        fillFrom = int(parsedInstList[i][1],16)
        i = i + 1;
        continue
    if (i == 0):
        raise Exception("UnhandledException")
    if (parsedInstList[i][0] in thirtyTwo):
        parseInst(parsedInstList[i], fillFrom)
        i += 1
        fillFrom += 2
        continue
    parseInst(parsedInstList[i], fillFrom)
    fillFrom += 1
    i += 1
f.close()
