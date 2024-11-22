import json
import subprocess
import re

def get_macsec_stats():
    result = subprocess.run(['ip','-s','macsec','show'], capture_output=True, text=True)
    return result.stdout
def parse_macsec_output(output):
    data = {}
    txsc_pattern = r'TXSC: (.*?)(?=RXSC:|$)'
    rxsc_pattern = r'RXSC: (.*?)(?=RXSC:|$)'

    txsc_matches = re.findall(txsc_pattern, output, re.DOTALL)
    rxsc_matches = re.findall(rxsc_pattern, output, re.DOTALL)
    data["TX"] = []
    data["RX"] = []
    for match in txsc_matches:
        tx_stats = parse_tx_stats(match)
        data["TX"].append(tx_stats)

    for match in rxsc_matches:
        rx_stats= parse_rx_stats(match)
        data["RX"].append(rx_stats)

    return data

def parse_tx_stats(tx_block):
    assoc_n=-1
    associations=[]
    lines = tx_block.strip().split('\n')
    for line in lines:
        match = re.match(r'(\d+):',line.strip())
        if match:
            assoc_n+=1
            association_data = {
                    "SA": int(match.group(0).split(':')[0]),
                    "State": line.strip().split()[4],
                    "KeyID": line.strip().split()[6],
                    "PN": int(line.strip().split()[2].split(',')[0])
            }
            associations.append(association_data)

    tx_data = {
            "TXSC": lines[0].split(' ')[0],
            "Status": lines[0].split()[1],
            "ActiveSA" : int(lines[0].split()[3]),
            "OutPktsEncrypted": int(lines[4].split()[1])
    }
    return [tx_data,associations]

def parse_rx_stats(block):

    assoc_n=-1
    associations=[]
    lines = block.strip().split('\n')

    for line in lines:
        match = re.match(r'(\d+):', line.strip())
        if match:
            assoc_n+=1
            association_data = {
                    "SA": int(match.group(0).split(':')[0]),
                    "State": line.strip().split()[4],
                    "KeyID" : line.strip().split()[6],
                    "PN": int(line.strip().split()[2].split(',')[0])
            }
            associations.append(association_data)

    rx_data = {
            "RXSC": lines[0].split(',')[0],
    }
    return [rx_data,associations]


def main():
    macsec_output=get_macsec_stats()
    #print(macsec_output)

    macsec_data=parse_macsec_output(macsec_output)
    #print(macsec_data)

    macsec_json = json.dumps(macsec_data, indent=4)
    print(macsec_json)

if __name__ == "__main__":
    main()
