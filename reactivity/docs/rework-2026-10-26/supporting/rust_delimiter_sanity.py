#!/usr/bin/env python3
"""Bounded NON-COMPILER delimiter sanity, never Rust syntax/type qualification.
Skips quoted/byte/C strings, raw strings, chars vs lifetimes, line comments and
nested block comments. Checks {},[],() only; does not expand macros/cfg/includes.
"""
import bisect,hashlib,json,sys
from pathlib import Path
MAX_BYTES=8*1024*1024
MAX_NESTING=4096
class SanityError(Exception): pass

def inspect(source):
    n=len(source);i=0;stack=[];starts=[0]+[j+1 for j,c in enumerate(source) if c=='\n']
    def location(at):
        line=bisect.bisect_right(starts,at)
        return {'line':line,'column':at-starts[line-1]+1,'offset':at}
    def error(message,at): return {'message':message,**location(at)}
    def ident(c):return c.isalnum() or c=='_' or ord(c)>127
    # Rust's optional file shebang is not a token tree; inner attributes are.
    shebang=1 if source.startswith('\ufeff') else 0
    if source.startswith('#!',shebang) and not source.startswith('#![',shebang):
        end=source.find('\n',shebang);i=n if end<0 else end+1
    while i<n:
        if source.startswith('//',i):
            end=source.find('\n',i+2);i=n if end<0 else end+1;continue
        if source.startswith('/*',i):
            begin=i;depth=1;i+=2
            while i<n and depth:
                if source.startswith('/*',i):
                    depth+=1
                    if depth>MAX_NESTING:return [error('block comment nesting exceeds sanity bound',i)]
                    i+=2
                elif source.startswith('*/',i):depth-=1;i+=2
                else:i+=1
            if depth:return [error('unterminated block comment',begin)]
            continue
        # Raw prefixes r, br and cr; do not start midway through an identifier.
        raw_start=None
        if i==0 or not ident(source[i-1]):
            for prefix in ('br','cr','r'):
                if source.startswith(prefix,i):
                    j=i+len(prefix)
                    while j<n and source[j]=='#':j+=1
                    if j<n and source[j]=='"':raw_start=(j,j-i-len(prefix));break
        if raw_start is not None:
            quote,hashes=raw_start
            if hashes>255:return [error('raw string hash count exceeds Rust/sanity bound',i)]
            close='"'+'#'*hashes;end=source.find(close,quote+1)
            if end<0:return [error('unterminated raw string',i)]
            i=end+len(close);continue
        if source[i]=='"':
            begin=i;i+=1
            while i<n:
                if source[i]=='\\':i+=2
                elif source[i]=='"':i+=1;break
                else:i+=1
            else:return [error('unterminated quoted string',begin)]
            continue
        if source[i]=="'":
            # A char has exactly one Unicode scalar or one escaped unit before
            # its closing apostrophe. Otherwise leave lifetime/label tokens alone.
            j=i+1
            if j<n and source[j]=='\\':
                j+=1
                if j<n and source[j]=='u' and j+1<n and source[j+1]=='{':
                    end=source.find('}',j+2);j=n if end<0 else end+1
                elif j<n and source[j]=='x':j+=3
                else:j+=1
                if j<n and source[j]=="'":i=j+1;continue
                return [error('unterminated/unsupported escaped char literal',i)]
            if j+1<n and source[j+1]=="'":i=j+2;continue
            i+=1;continue
        c=source[i]
        if c in '([{':
            stack.append((c,i))
            if len(stack)>MAX_NESTING:return [error('delimiter nesting exceeds sanity bound',i)]
        elif c in ')]}':
            expected={')':'(',']':'[','}':'{'}[c]
            if not stack:return [error('unexpected closing '+c,i)]
            if stack[-1][0]!=expected:
                opening,at=stack[-1]
                return [error('closing '+c+' mismatches '+opening,i),error('mismatched opener',at)]
            stack.pop()
        i+=1
    return [error('unclosed '+opening,at) for opening,at in stack]

def check(path):
    data=Path(path).read_bytes()
    if len(data)>MAX_BYTES:raise SanityError('file exceeds 8MiB bounded audit limit')
    text=data.decode('utf-8')
    return {'path':str(path),'sha256':hashlib.sha256(data).hexdigest(),'bytes':len(data),'errors':inspect(text),
            'scope':'NON-COMPILER lexical delimiter sanity ONLY; not Rust syntax/type/borrow/cfg/macro/include qualification'}
if __name__=='__main__':
    if len(sys.argv)<2:raise SystemExit('usage: python3 -I rust_delimiter_sanity.py FILE.rs [FILE.rs ...]')
    results=[]
    for path in sys.argv[1:]:
        try:results.append(check(path))
        except (OSError,UnicodeError,SanityError) as e:results.append({'path':path,'errors':[{'message':str(e)}]})
    print(json.dumps(results,indent=2))
    raise SystemExit(int(any(r['errors'] for r in results)))
