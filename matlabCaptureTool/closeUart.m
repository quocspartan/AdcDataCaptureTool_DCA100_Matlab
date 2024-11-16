fclose all;
scoms = instrfindall;
if (~isempty(scoms))
    stopasync(scoms);
    fclose(scoms);
    delete(scoms);    
end