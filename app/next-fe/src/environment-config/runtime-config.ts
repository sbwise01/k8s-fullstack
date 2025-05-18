type RuntimeConfig = {
  variable1: string;
  variable2: string;
  API_URL: string;
};
const runtimeConfig: RuntimeConfig = {
  variable1: process.env.RUNTIME_VARIABLE_1!,
  variable2: process.env.RUNTIME_VARIABLE_2!,
  API_URL: process.env.API_URL!,
};

export type { RuntimeConfig };

export { runtimeConfig };
