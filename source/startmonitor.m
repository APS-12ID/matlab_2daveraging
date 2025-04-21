s12DET = Pilatus;
s12DET = connect(s12DET);
s12DET = get(s12DET);
mcamon(s12DET.SeqNumber{2}, 'mcamon_test_callback');
mcamon(s12DET.ArrayNumber{2}, 'mcamon_test_callback');
%mcamon(s12DET.AcquirePOLL{2}, 'mcamon_test_callback');
mcamontimer('start')

