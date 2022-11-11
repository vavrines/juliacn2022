// gcc -g -Wall -shared -fPIC kit.c -o libkit.so

void test(double (*u)[2]) { u[0][1] = 2022.0; }