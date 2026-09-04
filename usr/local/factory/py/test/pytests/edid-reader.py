import os
import stat
import subprocess
import argparse

_def_file_name = "EDID_reading_result.txt"

def parse_arguments():
    parser = argparse.ArgumentParser(description='anx edid reader')
    parser.add_argument('--dump', '-d', action='store_true', help="dump edid in text")
    parser.add_argument('--file', '-f', type=str, default=_def_file_name, help='specific log file name')
    parser.add_argument('--edid', '-e', type=str, default='/sys/class/drm/card0-eDP-1/edid', help='specific edid file name')
    return parser.parse_args()

def read_edid_from_file(edid_file):
    with open(edid_file, 'rb') as f:
        edid_data = f.read()

    return edid_data

def parse_edid_by_read_file(edid_file, filename, dump):
    edid_data = read_edid_from_file(edid_file)

    i = 0
    if (dump):
        while i < len(edid_data) / 32:
            print(' '.join(f"{num:02x}" for num in edid_data[i*16:(i+1)*16]))
            i+=1

    if filename == _def_file_name:
        filename = f"{edid_data[8]:02X}{edid_data[9]:02X}_{edid_data[11]:02X}{edid_data[10]:02X}.txt"

    if os.path.exists(filename):
        try:
            os.remove(filename)
        except Exception as e:
            print(f"delete file {filename}: {e}")

    with open(filename, 'w') as f:
        print(f"Supplier:{edid_data[8]:02X}{edid_data[9]:02X}", file=f)
        print(f"PID:{edid_data[11]:02X}{edid_data[10]:02X}", file=f)
        print(f"TCON FW ver:{edid_data[12]:02X}", file=f)
        print(f"TOP FW ver:{edid_data[13]:02X}", file=f)

        print(f"Supplier:{edid_data[8]:02X}{edid_data[9]:02X}")
        print(f"PID:{edid_data[11]:02X}{edid_data[10]:02X}")
        print(f"TCON FW ver:{edid_data[12]:02X}")
        print(f"TOP FW ver:{edid_data[13]:02X}")

    os.chmod(filename, stat.S_IREAD)


def main():
    args = parse_arguments()
    parse_edid_by_read_file(args.edid, args.file, args.dump)

if __name__ == '__main__':
    main()
    exit()


