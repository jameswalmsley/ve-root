import os
import sys
import json
import jinja2

root=sys.argv[1]
destdir=sys.argv[2]
config=sys.argv[3]

print(root, destdir)

template_loader = jinja2.FileSystemLoader(searchpath=root)
template_env = jinja2.Environment(loader=template_loader)

with open(config) as f:
    data = json.load(f)

config=data

for path, subdirs, files in os.walk(root):
    for name in files:
        file=os.path.join(path, name)
        file=os.path.relpath(file, root)
        template = template_env.get_template(file)
        output = template.render(config=config, distro=config['distro'], system=config['system'])

        out = os.path.join(destdir, file)

        if not os.path.exists(os.path.dirname(out)):
            os.makedirs(os.path.dirname(out))

        print(out)

        with open(out, 'w') as f:
            f.write(output)

        #print(output)
