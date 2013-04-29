function[] = writeFile(str, fileName)

fid = fopen(strcat('./games/', fileName), 'w');
if fid ~= -1
    fprintf(fid, '%s', str);
    fclose(fid);
end