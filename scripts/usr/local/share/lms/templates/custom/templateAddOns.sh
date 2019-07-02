printf -v templateBuffer "%s\n%s" "${templateBuffer}" "-v \${HOME}/Downloads:/Downloads \\"
printf -v templateBuffer "%s\n%s" "${templateBuffer}" "-v \${HOME}/Source:/source \\"
