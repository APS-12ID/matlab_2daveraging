function p = APS12IDBpath(varargin)
p = [...
    '/home/beams15/S12IDB/Documents/MATLAB/mytool/APS12IDB:', ...
     '/home/beams15/S12IDB/Documents/MATLAB/mytool/CMS_SAXS:', ...
     '/home/beams15/S12IDB/Documents/MATLAB/mytool/bioSAXSproc/atsas/unix:', ...
     '/home/beams15/S12IDB/Documents/MATLAB/mytool/bioSAXSproc:', ...
     '/home/beams15/S12IDB/Documents/MATLAB/mytool/bioSAXSproc/atsas:', ...
     '/home/beams15/S12IDB/Documents/MATLAB/mytool/bioSAXSproc/example:', ...
     '/home/beams15/S12IDB/Documents/MATLAB/mytool/bioSAXSproc/fminsearchcon:', ...
     '/home/beams15/S12IDB/Documents/MATLAB/mytool/bioSAXSproc/fminsearchcon/demo:', ...
     '/home/beams15/S12IDB/Documents/MATLAB/mytool/bioSAXSproc/fminsearchcon/demo/html:', ...
     '/home/beams15/S12IDB/Documents/MATLAB/mytool/bioSAXSproc/fminsearchcon/doc:', ...
     '/home/beams15/S12IDB:', ...
     '/APSshare/epics/matlab/mca/matlab:', ...
     '/APSshare/epics/matlab/labca_3_1/bin/linux-x86_64-el5/labca:', ...
     '/APSshare/epics/matlab/mca/O.linux-x86_64-el5:', ...
     '/home/beams15/S12IDB/Documents/MATLAB/mytool:', ...
     '/home/beams15/S12IDB/Documents/MATLAB/mytool/1DSAXS:', ...
     '/home/beams15/S12IDB/Documents/MATLAB/mytool/1DSAXS/GUI:', ...
     '/home/beams15/S12IDB/Documents/MATLAB/mytool/1DSAXS/GUI/SAXSLee_resources:', ...
     '/home/beams15/S12IDB/Documents/MATLAB/mytool/1danalysis:', ...
     '/home/beams15/S12IDB/Documents/MATLAB/mytool/2Danalysis:', ...
     '/home/beams15/S12IDB/Documents/MATLAB/mytool/2Danalysis/agbh_analysis:', ...
     '/home/beams15/S12IDB/Documents/MATLAB/mytool/Correlationfunction:', ...
     '/home/beams15/S12IDB/Documents/MATLAB/mytool/FFT2new:', ...
     '/home/beams15/S12IDB/Documents/MATLAB/mytool/GiSAXS:', ...
     '/home/beams15/S12IDB/Documents/MATLAB/mytool/GiSAXS/DWBA_HPL:', ...
     '/home/beams15/S12IDB/Documents/MATLAB/mytool/GiSAXS/DWBAvsKinematic:', ...
     '/home/beams15/S12IDB/Documents/MATLAB/mytool/GiSAXS/GUI2:', ...
     '/home/beams15/S12IDB/Documents/MATLAB/mytool/GiSAXS/GUI2/gifit:', ...
     '/home/beams15/S12IDB/Documents/MATLAB/mytool/GiSAXS/GUI2/icons:', ...
     '/home/beams15/S12IDB/Documents/MATLAB/mytool/GiSAXS/TMVonPS:', ...
     '/home/beams15/S12IDB/Documents/MATLAB/mytool/GiSAXS/sphere_simulation:', ...
     '/home/beams15/S12IDB/Documents/MATLAB/mytool/Mydistribution:', ...
     '/home/beams15/S12IDB/Documents/MATLAB/mytool/PLS_SAXS:', ...
     '/home/beams15/S12IDB/Documents/MATLAB/mytool/Waxs:', ...
     '/home/beams15/S12IDB/Documents/MATLAB/mytool/abs_intensity:', ...
     '/home/beams15/S12IDB/Documents/MATLAB/mytool/dataGui:', ...
     '/home/beams15/S12IDB/Documents/MATLAB/mytool/dataformat:', ...
     '/home/beams15/S12IDB/Documents/MATLAB/mytool/debye:', ...
     '/home/beams15/S12IDB/Documents/MATLAB/mytool/download:', ...
     '/home/beams15/S12IDB/Documents/MATLAB/mytool/download/Annotate_2D:', ...
     '/home/beams15/S12IDB/Documents/MATLAB/mytool/download/DeMat:', ...
     '/home/beams15/S12IDB/Documents/MATLAB/mytool/download/SubAxis:', ...
     '/home/beams15/S12IDB/Documents/MATLAB/mytool/download/circle_fit:', ...
     '/home/beams15/S12IDB/Documents/MATLAB/mytool/download/crosshair:', ...
     '/home/beams15/S12IDB/Documents/MATLAB/mytool/download/cursors:', ...
     '/home/beams15/S12IDB/Documents/MATLAB/mytool/download/data_visualization:', ...
     '/home/beams15/S12IDB/Documents/MATLAB/mytool/download/data_visualization/compressed:', ...
     '/home/beams15/S12IDB/Documents/MATLAB/mytool/download/data_visualization/dataviz:', ...
     '/home/beams15/S12IDB/Documents/MATLAB/mytool/download/data_visualization/dataviz/demo:', ...
     '/home/beams15/S12IDB/Documents/MATLAB/mytool/download/diffusion:', ...
     '/home/beams15/S12IDB/Documents/MATLAB/mytool/download/digitalc:', ...
     '/home/beams15/S12IDB/Documents/MATLAB/mytool/download/exportfig:', ...
     '/home/beams15/S12IDB/Documents/MATLAB/mytool/download/ezyfit2.10:', ...
     '/home/beams15/S12IDB/Documents/MATLAB/mytool/download/ezyfit2.10/ezyfit:', ...
     '/home/beams15/S12IDB/Documents/MATLAB/mytool/download/ezyfit2.10/ezyfit/html:', ...
     '/home/beams15/S12IDB/Documents/MATLAB/mytool/download/fit_gaussian:', ...
     '/home/beams15/S12IDB/Documents/MATLAB/mytool/download/gratingdiffraction:', ...
     '/home/beams15/S12IDB/Documents/MATLAB/mytool/download/gridfitdir:', ...
     '/home/beams15/S12IDB/Documents/MATLAB/mytool/download/gridfitdir/demo:', ...
     '/home/beams15/S12IDB/Documents/MATLAB/mytool/download/gridfitdir/demo/html:', ...
     '/home/beams15/S12IDB/Documents/MATLAB/mytool/download/gridfitdir/doc:', ...
     '/home/beams15/S12IDB/Documents/MATLAB/mytool/download/gridfitdir/test:', ...
     '/home/beams15/S12IDB/Documents/MATLAB/mytool/download/gui_act:', ...
     '/home/beams15/S12IDB/Documents/MATLAB/mytool/download/gui_act/gui_act:', ...
     '/home/beams15/S12IDB/Documents/MATLAB/mytool/download/html:', ...
     '/home/beams15/S12IDB/Documents/MATLAB/mytool/download/icon_edit_16x16:', ...
     '/home/beams15/S12IDB/Documents/MATLAB/mytool/download/icon_edit_16x16/icon_edit_16x16:', ...
     '/home/beams15/S12IDB/Documents/MATLAB/mytool/download/jtcp:', ...
     '/home/beams15/S12IDB/Documents/MATLAB/mytool/download/jtcp/jtcp:', ...
     '/home/beams15/S12IDB/Documents/MATLAB/mytool/download/molecule_pdb:', ...
     '/home/beams15/S12IDB/Documents/MATLAB/mytool/download/plotmydata_develop:', ...
     '/home/beams15/S12IDB/Documents/MATLAB/mytool/download/pointsinpolyhedron:', ...
     '/home/beams15/S12IDB/Documents/MATLAB/mytool/download/pointsinpolyhedron/html:', ...
     '/home/beams15/S12IDB/Documents/MATLAB/mytool/download/powerspectrum:', ...
     '/home/beams15/S12IDB/Documents/MATLAB/mytool/download/sginfo_1_01:', ...
     '/home/beams15/S12IDB/Documents/MATLAB/mytool/download/sginfo_1_01/Debug:', ...
     '/home/beams15/S12IDB/Documents/MATLAB/mytool/download/sginfo_1_01/cgi:', ...
     '/home/beams15/S12IDB/Documents/MATLAB/mytool/download/stats:', ...
     '/home/beams15/S12IDB/Documents/MATLAB/mytool/download/tcp_udp_ip:', ...
     '/home/beams15/S12IDB/Documents/MATLAB/mytool/download/tcp_udp_ip/UDP_SIM_DAQ_DEMO:', ...
     '/home/beams15/S12IDB/Documents/MATLAB/mytool/download/tcp_udp_ip/old:', ...
     '/home/beams15/S12IDB/Documents/MATLAB/mytool/download/terrain_generation:', ...
     '/home/beams15/S12IDB/Documents/MATLAB/mytool/download/terrain_generation/html:', ...
     '/home/beams15/S12IDB/Documents/MATLAB/mytool/download/xraylabtool:', ...
     '/home/beams15/S12IDB/Documents/MATLAB/mytool/download/xraylabtool/fittool:', ...
     '/home/beams15/S12IDB/Documents/MATLAB/mytool/download/xraylabtool/specreader:', ...
     '/home/beams15/S12IDB/Documents/MATLAB/mytool/download/xraylabtool/specreader/.svn:', ...
     '/home/beams15/S12IDB/Documents/MATLAB/mytool/download/xraylabtool/specreader/.svn/prop-base:', ...
     '/home/beams15/S12IDB/Documents/MATLAB/mytool/download/xraylabtool/specreader/.svn/text-base:', ...
     '/home/beams15/S12IDB/Documents/MATLAB/mytool/download/xraylabtool/xrayrefraction:', ...
     '/home/beams15/S12IDB/Documents/MATLAB/mytool/download/xraylabtool/xrayrefraction/AtomicScatteringFactor:', ...
     '/home/beams15/S12IDB/Documents/MATLAB/mytool/drawing_tool:', ...
     '/home/beams15/S12IDB/Documents/MATLAB/mytool/drawing_tool/arrow:', ...
     '/home/beams15/S12IDB/Documents/MATLAB/mytool/drawing_tool/arrow3:', ...
     '/home/beams15/S12IDB/Documents/MATLAB/mytool/drawing_tool/geom2d:', ...
     '/home/beams15/S12IDB/Documents/MATLAB/mytool/drawing_tool/geom3d:', ...
     '/home/beams15/S12IDB/Documents/MATLAB/mytool/drawing_tool/geom3d/geom3d:', ...
     '/home/beams15/S12IDB/Documents/MATLAB/mytool/drawing_tool/geom3d/geom3d-demos:', ...
     '/home/beams15/S12IDB/Documents/MATLAB/mytool/drawing_tool/geom3d/geom3d-demos/html:', ...
     '/home/beams15/S12IDB/Documents/MATLAB/mytool/drawing_tool/geom3d/meshes3d:', ...
     '/home/beams15/S12IDB/Documents/MATLAB/mytool/drawing_tool/geom3d/meshes3d-demos:', ...
     '/home/beams15/S12IDB/Documents/MATLAB/mytool/drawing_tool/geom3d/meshes3d-demos/html:', ...
     '/home/beams15/S12IDB/Documents/MATLAB/mytool/drawing_tool/geom3d-demos:', ...
     '/home/beams15/S12IDB/Documents/MATLAB/mytool/drawing_tool/geom3d-demos/html:', ...
     '/home/beams15/S12IDB/Documents/MATLAB/mytool/drawing_tool/geom3d_old:', ...
     '/home/beams15/S12IDB/Documents/MATLAB/mytool/euler:', ...
     '/home/beams15/S12IDB/Documents/MATLAB/mytool/export_fig:', ...
     '/home/beams15/S12IDB/Documents/MATLAB/mytool/export_fig/.ignore:', ...
     '/home/beams15/S12IDB/Documents/MATLAB/mytool/ezyfit:', ...
     '/home/beams15/S12IDB/Documents/MATLAB/mytool/ezyfit/demo:', ...
     '/home/beams15/S12IDB/Documents/MATLAB/mytool/ezyfit/demo/html:', ...
     '/home/beams15/S12IDB/Documents/MATLAB/mytool/ezyfit/html:', ...
     '/home/beams15/S12IDB/Documents/MATLAB/mytool/fitting:', ...
     '/home/beams15/S12IDB/Documents/MATLAB/mytool/fitting/fit:', ...
     '/home/beams15/S12IDB/Documents/MATLAB/mytool/fitting/fminsearchcon:', ...
     '/home/beams15/S12IDB/Documents/MATLAB/mytool/fitting/fminsearchcon/demo:', ...
     '/home/beams15/S12IDB/Documents/MATLAB/mytool/fitting/fminsearchcon/demo/html:', ...
     '/home/beams15/S12IDB/Documents/MATLAB/mytool/fitting/fminsearchcon/doc:', ...
     '/home/beams15/S12IDB/Documents/MATLAB/mytool/fitting/immoptibox:', ...
     '/home/beams15/S12IDB/Documents/MATLAB/mytool/fitting/opt_reg_tips:', ...
     '/home/beams15/S12IDB/Documents/MATLAB/mytool/imageDraw:', ...
     '/home/beams15/S12IDB/Documents/MATLAB/mytool/license:', ...
     '/home/beams15/S12IDB/Documents/MATLAB/mytool/lipid:', ...
     '/home/beams15/S12IDB/Documents/MATLAB/mytool/maxent:', ...
     '/home/beams15/S12IDB/Documents/MATLAB/mytool/packing:', ...
     '/home/beams15/S12IDB/Documents/MATLAB/mytool/pdb:', ...
     '/home/beams15/S12IDB/Documents/MATLAB/mytool/pdb/downloads:', ...
     '/home/beams15/S12IDB/Documents/MATLAB/mytool/pdb/downloads/StoichTools:', ...
     '/home/beams15/S12IDB/Documents/MATLAB/mytool/pdb/downloads/StoichTools/html:', ...
     '/home/beams15/S12IDB/Documents/MATLAB/mytool/pdb/downloads/pdb2mat:', ...
     '/home/beams15/S12IDB/Documents/MATLAB/mytool/pdb/downloads/pertable:', ...
     '/home/beams15/S12IDB/Documents/MATLAB/mytool/saxs:', ...
     '/home/beams15/S12IDB/Documents/MATLAB/mytool/saxs/GUI:', ...
     '/home/beams15/S12IDB/Documents/MATLAB/mytool/saxsnew:', ...
     '/home/beams15/S12IDB/Documents/MATLAB/mytool/smooth:', ...
     '/home/beams15/S12IDB/Documents/MATLAB/mytool/spacegroup:', ...
     '/home/beams15/S12IDB/Documents/MATLAB/mytool/spacegroup/cmpr:', ...
     '/home/beams15/S12IDB/Documents/MATLAB/mytool/spec:', ...
     '/home/beams15/S12IDB/Documents/MATLAB/mytool/structurefactor:', ...
     '/home/beams15/S12IDB/Documents/MATLAB/mytool/structurefactor/TYSQ21:', ...
     '/home/beams15/S12IDB/Documents/MATLAB/mytool/structurefactor/TYSQ21/TYSQ21:', ...
     '/home/beams15/S12IDB/Documents/MATLAB/mytool/xray:', ...
     ];
 p = [path;p];