import zipfile
import shutil
import sys

def fix_order(path):
    tmp = path + '.tmp'
    with zipfile.ZipFile(path, 'r') as zin:
        names = zin.namelist()
        # Content_Types must be first per OPC spec
        ordered = ['[Content_Types].xml'] + [n for n in names if n != '[Content_Types].xml']
        infos = {i.filename: i for i in zin.infolist()}
        with zipfile.ZipFile(tmp, 'w', zipfile.ZIP_DEFLATED) as zout:
            for name in ordered:
                data = zin.read(name)
                zout.writestr(infos[name], data)
    shutil.move(tmp, path)
    print('Reordered:', path)

if __name__ == '__main__':
    fix_order(sys.argv[1])
