import json


abi_name = input("Name file: ")

result = "interface " + abi_name.split(".")[0] + " {\n"

abi = json.load(open(abi_name,"r"))

def convertType(_type):
    if _type == "cell":
        _type = "TvmCell"
    return _type

for i in abi["functions"]:
    if i['name'] == "constructor":
        continue
    else:
        result += f"    function {i['name']}("
    for x in i["inputs"]:
        _type = convertType(x["type"])
        
        result += f"{_type} {x['name']},"
    if len(i["inputs"]) > 0:
        result = result[:-1] + ") external"
    else:
        result += ") external"
    if len(i["outputs"]) > 0:
        result += " returns ("
        for x in i["outputs"]:
            result += f"{convertType(x['type'])} {x['name']},"
        result = result[:-1] + ")"
    result += ";\n"
result += "}"
print(result)
