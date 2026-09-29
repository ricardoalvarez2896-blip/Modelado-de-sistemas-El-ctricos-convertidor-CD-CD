% =========================================================================
% Práctica 6 - Ejercicio 1: Modelo en Espacio de Estados preciso
% =========================================================================

% 1. Parámetros del sistema
L = 0.002;      % Inductancia (2 mH)
C = 10e-6;     % Capacitancia (10 uF)
R = 10;        % Resistencia (10 Ohm)
Uin = 32;      % Voltaje de entrada (32 V)

f = 100e3;     % Frecuencia del PWM (100 kHz)
T = 1/f;       % Periodo de conmutación (10 us)
D = 0.4;       % Ciclo de trabajo (40%)

% 2. Matrices en Espacio de Estados
A = [0,     -1/L; 
     1/C, -1/(R*C)];

B = [Uin/L; 
     0];

% 3. Tiempo de simulación y opciones del resolvedor
tspan = [0, 0.002]; % 2 milisegundos de simulación
x0 = [0; 0];        % Condiciones iniciales en cero

% Ajuste crítico: limitar el paso máximo a 0.1 microsegundos
options = odeset('MaxStep', 1e-7); 

% 4. Resolución del sistema con ode45
[t, x] = ode45(@(t, x) sistema_pwm(t, x, A, B, T, D), tspan, x0, options);

% 5. Graficar la respuesta completa y el zoom
figure('Name', 'Convertidor CD-CD (Modelo ode45)');

% Corriente en el inductor iL(t)
subplot(2,1,1);
plot(t*1000, x(:,1), 'b');
title('Corriente en el Inductor i_L(t)');
ylabel('Corriente (A)'); grid on;

% Voltaje en el capacitor Vc(t)
subplot(2,1,2);
plot(t*1000, x(:,2), 'r');
title('Voltaje en el Capacitor V_c(t)');
xlabel('Tiempo (ms)'); ylabel('Voltaje (V)'); grid on;

% Función local del PWM
function dxdt = sistema_pwm(t, x, A, B, T, D)
    if mod(t, T) <= D*T
        d = 1;
    else
        d = 0;
    end
    dxdt = A*x + B*d;
end