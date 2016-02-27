function V = vcalcGHK(concCisK,concCisCl,concTransK,concTransCl,R,c)
V = (c.kT/c.e)*log((R*concCisK+concTransCl)./((R*concTransK+concCisCl)));
end
