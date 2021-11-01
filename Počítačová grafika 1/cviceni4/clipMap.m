function out = clipMap(in,minimum,maximum)

out = in;

out(out>maximum)=maximum;
out(out<minimum)=minimum;
end

