"""Explicit lexical fixtures only. NEVER rustc/parser/type qualification."""
from pathlib import Path
import importlib.util,json,hashlib
here=Path(__file__).resolve().parent
spec=importlib.util.spec_from_file_location('sanity',here/'rust_delimiter_sanity.py');m=importlib.util.module_from_spec(spec);spec.loader.exec_module(m)
valid={
 'ordinary': 'fn f(){let a=[(1,2)];}',
 'file_shebang': '#!/synthetic/path)]}\nfn f(){}',
 'inner_attribute': '#![allow(dead_code)]\nfn f(){}',
 'quoted_delimiters': r'''fn f(){let s=" )]} {[( // /* \\\" ";}''',
 'byte_c_strings': r'''fn f(){let a=b"[{]}";let b=c"/* )] */";}''',
 'raw_strings': 'fn f(){let a=r###" } ] ) " ## /* ' + "'" + ' ###"###;}',
 'raw_byte_c_strings': 'fn f(){let a=br##" ) } ] // "##;let b=cr#" ( { [ "#;}',
 'multiline_raw': 'fn f(){let a=r"first\n} ) ]\nlast";}',
 'chars_and_bytes': r'''fn f(){let a='{';let b=b']';let c='\'';let d='\\';let e='\n';}''',
 'unicode_char': r'''fn f(){let a='\u{007d}';let b='\x7b';let c='é';}''',
 'lifetimes_labels': "fn f<'a,'b>(x:&'a str,y:&'b str){'outer: loop { break 'outer; }}",
 'lifetime_and_chars': "fn f<'a>(x:&'a str){let a='a';let b='_';}",
 'line_comments': 'fn f(){// } ) ] /*\nlet x=();}//tail (\n',
 'nested_block_comments': 'fn f(){/* } /* ] /* ) */ ] */ } */let x=();}',
 'macro_tokens': 'macro_rules! a { ($($t:tt)*) => { [$($t)*] }; }',
 'raw_identifier': 'fn r#type(){let r#match=0;}',
 'escaped_newline': 'fn f(){let a="str\\\n } ] )";}',
}
invalid={
 'missing_closing': 'mod tests { fn f() { assert!(true); }',
 'unexpected_closing': 'fn f(){} }',
 'mismatch': 'fn f(){let a=[1,2);}',
 'unterminated_string': 'fn f(){let a="unterminated }',
 'unterminated_raw': 'fn f(){let a=r###" } "##;}',
 'unterminated_nested_comment': 'fn f(){/* outer /* inner */ }',
 'unterminated_escape_char': r"fn f(){let x='\u{0041};}",
 'bounded_nesting': '('*(m.MAX_NESTING+1),
 'bounded_raw_hashes': 'r'+'#'*256+'"text"'+'#'*256,
}
checks=[]
for label,text in valid.items():
 errors=m.inspect(text);assert not errors,(label,errors,text);checks.append({'case':label,'expected':'balanced','errors':errors})
for label,text in invalid.items():
 errors=m.inspect(text);assert errors,(label,text);checks.append({'case':label,'expected':'rejected','errors':errors})
report={'scope':'NON-COMPILER lexical fixtures ONLY; no Rust tools, builds, or source mutation',
 'checker_sha256':hashlib.sha256((here/'rust_delimiter_sanity.py').read_bytes()).hexdigest(),
 'synthetic_cases':len(checks),'checks':checks}
print(json.dumps(report,indent=2))
