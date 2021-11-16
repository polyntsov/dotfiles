# Defined in - @ line 1
function ll --wraps='ls -alF' --description 'alias ll ls -alF'
  ls -alF $argv;
end
