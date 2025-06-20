import os, re, subprocess, sys

labels = {}
rst_files = []
for root, dirs, files in os.walk('.'):
    if root.startswith('./locale') or root.startswith('./i18n'):
        continue
    for f in files:
        if f.endswith('.rst'):
            path = os.path.join(root, f)
            rst_files.append(path)
            with open(path, encoding='utf-8') as fr:
                for line in fr:
                    m = re.match(r'\s*\.\.\s*_([A-Za-z0-9_.-]+):', line)
                    if m:
                        labels[m.group(1)] = path

for rst in rst_files:
    md = rst[:-4] + '.md'
    subprocess.run(['pandoc','-f','rst','-t','markdown','--markdown-headings=atx','--wrap','preserve',rst,'-o',md], check=True)

    with open(md, encoding='utf-8') as f:
        md_text = f.read()

    def resolve(label):
        target = labels.get(label)
        if not target:
            return None
        target_md = target[:-4] + '.md'
        return os.path.relpath(target_md, os.path.dirname(md))

    def repl_ref(match):
        text = match.group(1)
        label = match.group(2) or text
        href = resolve(label)
        if href:
            if href == os.path.basename(md):
                url = f"#{label}"
            else:
                url = f"{href}#{label}"
            return f"[{text}]({url})"
        return text

    md_text = re.sub(r':ref:`([^`<]+?)\s*<([^`]+)>`', repl_ref, md_text)
    md_text = re.sub(r':ref:`([^`]+?)`', repl_ref, md_text)
    md_text = re.sub(r':doc:`([^`<]+?)\s*<([^`]+)>`', lambda m: f"[{m.group(1)}]({m.group(2)}.md)", md_text)
    md_text = re.sub(r':doc:`([^`]+?)`', lambda m: f"[{m.group(1)}]({m.group(1)}.md)", md_text)

    # append toctree links from rst
    sections = []
    lines = open(rst, encoding='utf-8').read().splitlines()
    i = 0
    while i < len(lines):
        if lines[i].startswith('.. toctree::'):
            caption = None
            i += 1
            while i < len(lines) and re.match(r'\s+:', lines[i]):
                if re.match(r'\s+:caption:', lines[i]):
                    caption = lines[i].split(':caption:')[1].strip()
                i += 1
            while i < len(lines) and not lines[i].strip():
                i += 1
            entries = []
            while i < len(lines) and lines[i].strip():
                entries.append(lines[i].strip())
                i += 1
            sections.append((caption, entries))
        else:
            i += 1

    if sections:
        md_text += '\n\n'
    for caption, entries in sections:
        if caption:
            md_text += f"### {caption}\n"
        for e in entries:
            md_text += f"- [{os.path.basename(e)}]({e}.md)\n"
        md_text += '\n'

    with open(md, 'w', encoding='utf-8') as f:
        f.write(md_text)
