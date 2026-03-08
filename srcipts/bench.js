import http from 'k6/http';
import { check, sleep } from 'k6';
import { randomIntBetween } from 'https://jslib.k6.io/k6-utils/1.2.0/index.js';

export const options = {
  stages: [
    { duration: '5s', target: 20 }, 
    { duration: '20s', target: 100 },
  ],
};

export default function () {
  const homeRes = http.get('http://localhost:10000/');
  check(homeRes, { 'home status 200': (r) => r.status === 200 });

  const randomId = Math.floor(Math.random() * 10000);
  const dynamicRes = http.get(`http://localhost:10000/users/${randomId}`);
  
  check(dynamicRes, {
    'dynamic status 200': (r) => r.status === 200,
    'dynamic latency < 150ms': (r) => r.timings.duration < 150,
  });

  sleep(0.1);
}