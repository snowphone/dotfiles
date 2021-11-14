$pdf_mode = 4; # Use LuaLaTeX by default. Try 1 if you want pdfLaTeX.
$preview_mode = 1;
$pdf_update_method = 2;
$pdf_previewer = 'xdg-open';

$clean_ext = 'bbl rel %R-blx.bib %R.synctex.gz aux nav snm thm soc loc glg acn out vrb fdb_latexmk fls';
push @generated_exts, 'auxlock', 'synctex.gz', 'run.xml', 'nav', 'snm', 'vrb', 'fdb_latexmk', 'fls';

set_tex_cmds( '-synctex=0' )
