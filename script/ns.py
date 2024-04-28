import sys

def compare_name_servers(name_servers_dig, name_servers_route53):
    if name_servers_route53.issubset(name_servers_dig):
        print("Os Name Servers correspondem exatamente entre dig e Route 53.")
        sys.exit(0)
    else:
        print("Há uma diferença nos Name Servers entre dig e Route 53.")
        print("Name Servers via dig:")
        print(name_servers_dig)
        print("Name Servers via Route 53:")
        print(name_servers_route53)
        sys.exit(1)

def main():
    import sys

    if len(sys.argv) != 3:
        print("Uso: python script.py name_servers_route53 name_servers_dig")
        sys.exit(1)

    name_servers_dig = [ns[:-1] if ns.endswith('.') else ns for ns in  set(sys.argv[2].split(","))]
    name_servers_route53 = set(sys.argv[1].split(","))
    compare_name_servers(name_servers_dig, name_servers_route53)

if __name__ == "__main__":
    main()