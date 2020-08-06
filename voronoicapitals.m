% VoronoiCapitals: Map Voronoi domains on the spherical Earth based on capital city locations
% 
% Requires M_MAP 
%   https://www.eoas.ubc.ca/~rich/map.html
% Requires voronoi-sphere 
%   https://www.mathworks.com/matlabcentral/fileexchange/40989-voronoi-sphere
% Requires Natural Earth simplified populated place data
%   https://www.naturalearthdata.com/http//www.naturalearthdata.com/download/110m/cultural/ne_110m_populated_places_simple.zip
% Data converted to CSV using https://anyconv.com/dbf-to-csv-converter/

% Load place data, get longitude and latitude of capitals
load places;
rows = find(strcmp(Places.featureclaC50,"Admin-0 capital"));
clon = Places.longitudeN1911(rows);
clat = Places.latitudeN1911(rows);

[x,y,z] = sph2cart(clon*pi/180,clat*pi/180,1);
[Vertices, K, voronoiboundary, s] = voronoisphere([x'; y'; z']);

for i=1:length(voronoiboundary)
    [vlon2{i},vlat{i},r] = cart2sph(voronoiboundary{i}(1,:),voronoiboundary{i}(2,:),voronoiboundary{i}(3,:) );
    % Delete Voronoi paths that wrap around 180 longitude
    vlon2{i}(abs(vlon2{i} - mean(vlon2{i})) > pi) = NaN;
end

clf
%m_proj('Miller','long',[5 26],'lat',[35 50])
%m_proj('Miller','long',[-20 80],'lat',[15 65])  % Blow up Europe
%m_proj('Hammer-Aitoff','long',[-180 180],'lat',[-90 90])
m_proj('Robinson','long',[-180 180],'lat',[-90 90])
%m_patch([-20 80 80 -20],[15 15 65 65],'b','EdgeColor','b')
m_coast('patch','w','EdgeColor','none');
hold on
m_plot(clon,clat,'r.')
for i=1:length(vlon2)
    m_plot(vlon2{i}*180/pi,vlat{i}*180/pi,'k-')
end
%m_patch(vlon2{190}*180/pi,vlat{190}*180/pi,'g')
%m_patch(vlon2{1}*180/pi,vlat{1}*180/pi,'b')
axis equal
m_grid('box','fancy','linestyle',':','gridcolor','k','backcolor',[.2 .65 1]);