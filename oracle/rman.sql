configure snapshot controlfile name to '/oracle/ora11/product/dbs/snapcf_ora11gxxx.f';
crosscheck controlfilecopy '/oracle/ora11/product/dbs/snapcf_ora11g.f';
delete expired controlfilecopy '/oracle/ora11/product/dbs/snapcf_ora11g.f';
delete noprompt obsolete;
configure snapshot controlfile name to '/oracle/ora11/product/dbs/snapcf_ora11g.f';
