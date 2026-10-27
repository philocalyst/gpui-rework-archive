from pathlib import Path
p=Path('/home/user/gpui-local-publication-lab/reactivity/crates/gpui/tests/local_publication.rs');s=p.read_text();start=s.index('            eprintln!(\n                "DECORATED');end=s.index('            let before = text_state(&win);',start);s=s[:start]+s[end:];p.write_text(s)
p=Path('/home/user/gpui-local-publication-lab/reactivity/crates/gpui/src/runtime/sparse_text.rs');s=p.read_text();old='''            println!(
                "LOCAL_PUBLICATION,{case},updates=80,patches={patches},full={full},unchanged_layout={unchanged_layout}"
            );''';assert s.count(old)==1;s=s.replace(old,old+'''
            if matches!(case, "stream" | "stream-owner") {
                assert!(patches > 0, "representative {case} never admitted");
            }''');p.write_text(s)
