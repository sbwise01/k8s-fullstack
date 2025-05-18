import Image from "next/image";
import Iframe from 'react-iframe';
import { Inter } from "next/font/google";

const inter = Inter({ subsets: ["latin"] });

import {
  RuntimeConfig,
  runtimeConfig,
} from "@/environment-config/runtime-config";
import { buildTimeConfig } from "@/environment-config/build-time-config";

export default function Home({
  runtimeConfig,
}: {
  runtimeConfig: RuntimeConfig;
}) {
  return (
    <div className={"max-w-4xl mx-auto py-12"}>
      <div className="overflow-hidden bg-white shadow sm:rounded-lg">
        <div className="px-4 py-6 sm:px-6">
          <h3 className="text-base font-semibold leading-7 text-gray-900">
            Environment Variables
          </h3>
        </div>
        <div className="border-t border-gray-100">
          <dl className="divide-y divide-gray-100">
            <div className="px-4 py-6 sm:grid sm:grid-cols-3 sm:gap-4 sm:px-6">
              <dt className="text-sm font-medium text-gray-900">
                Runtime Variable 1
              </dt>
              <dd className="mt-1 text-sm leading-6 text-gray-700 sm:col-span-2 sm:mt-0">
                {runtimeConfig.variable1}
              </dd>
            </div>
            <div className="px-4 py-6 sm:grid sm:grid-cols-3 sm:gap-4 sm:px-6">
              <dt className="text-sm font-medium text-gray-900">
                Runtime Variable 2
              </dt>
              <dd className="mt-1 text-sm leading-6 text-gray-700 sm:col-span-2 sm:mt-0">
                {runtimeConfig.variable2}
              </dd>
            </div>
            <div className="px-4 py-6 sm:grid sm:grid-cols-3 sm:gap-4 sm:px-6">
              <dt className="text-sm font-medium text-gray-900">
                Build Time Variable
              </dt>
              <dd className="mt-1 text-sm leading-6 text-gray-700 sm:col-span-2 sm:mt-0">
                {buildTimeConfig.appName}
              </dd>
              <Iframe url={runtimeConfig.API_URL}
                      width="640px"
                      height="320px"
                      id=""
                      className=""
                      display="block"
                      position="relative"/>
            </div>
          </dl>
        </div>
      </div>
    </div>
  );
}

export async function getServerSideProps() {
  return {
    props: {
      runtimeConfig,
    },
  };
}
