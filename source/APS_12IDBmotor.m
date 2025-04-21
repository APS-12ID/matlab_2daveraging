motorName = {'chi', 'chi', 'm1';
    'theta', 'th', 'm5';
    'SampleV', 'sav', 'm6';
    'phi', 'phi', 'm8';
    'SamTabH', 'sth', 'm24';
    'pinhV', 'pinhV', 'm21';
    'pinhH', 'pinhH', 'm22';
    'beamstopVert', 'bstv', 'm25';
    'beamstopHor', 'bsth', 'm26'};
for i=1:size(motorName, 1)
    s12motor.(motorName{i, 1}) = connect(motor('12idb:', motorName{i, 3}));
    s12motor.(motorName{i, 1}) = get(s12motor.(motorName{i, 1})); 
end 