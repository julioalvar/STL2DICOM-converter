% This function determines if a point belongs to a plane with coefficients
% a,b,c,d. In continous space, the difference of the calculated coeffient d
% with the point using the plane values a,b,c must be zero. In discrete
% space we must allowed a difference threshold. A good threshold could be
% some value around 0.9.
function yesOrNo = pointBelongsToPlane(a,b,c,d,Point,differenceThreshold)

actual_d = [a b c ] * Point';

difference_of_ds = abs(actual_d-d);

yesOrNo = logical( difference_of_ds < differenceThreshold );