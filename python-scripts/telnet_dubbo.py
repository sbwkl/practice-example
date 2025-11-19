#!/usr/local/bin/python3
"""用于替代 macOS 下的 telnet 以方便调试 dubbo 接口
Example:
    ./telent_dubbo.py localhost 20880
    
"""

import sys
import telnetlib
import platform
if platform.system() != "Windows":
    try:
        import readline
    except ImportError:
        print("May need install package readline")

host = sys.argv[1]
port = sys.argv[2]
encoding = "GBK"

if len(sys.argv)==4:
    encoding = sys.argv[3]


tn = telnetlib.Telnet(host, port)
cmd = None
def remove_last_line_from_string(s):
    return s[:s.rfind('\n')]
while cmd != "exit":
    cmd = input("> ").strip()
    tn.write(cmd.encode(encoding) + b"\n")
    if cmd != "exit":
        result = tn.read_until(b"dubbo>").decode(encoding)
        result = remove_last_line_from_string(result)
        print(result)