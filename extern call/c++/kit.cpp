#include "jlcxx/jlcxx.hpp"
#include "xtensor-julia/jltensor.hpp" // Import the jltensor container definition
#include "xtensor/xmath.hpp"
#define PI acos(-1.0)

void test(double (*u)[2]) { u[0][1] = 2022.0; }
void test1(xt::jltensor<double, 2> u) { u(0, 1) = 2022.0; }

void test2(jlcxx::ArrayRef<double, 2> u) {
  u[0, 1] = 2022.0;
}

template <typename T> void maxwellian_xt(T H, T u, T prim) {
  int nu = H.shape(0);
  for (int i = 0; i < nu; i++) {
    H[i] = prim[0] * pow(prim[2] / PI, 0.5) *
           exp(-prim[2] * pow(u[i] - prim[1], 2));
  }
}

JLCXX_MODULE define_julia_module(jlcxx::Module &mod) {
  mod.method("test1", &test1);
  mod.method("test2", &test2);
  mod.method(
      "maxwellian_xt",
      static_cast<void (*)(xt::jltensor<double, 1>, xt::jltensor<double, 1>,
                           xt::jltensor<double, 1>)>(&maxwellian_xt));
}