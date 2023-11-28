classdef Motor_de_Simulacion_del_Movimiento_exported < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        UIFigure                        matlab.ui.Figure
        RightPanel                      matlab.ui.container.Panel
        TiempoEditField                 matlab.ui.control.NumericEditField
        TiempoEditFieldLabel            matlab.ui.control.Label
        PosicinyEditField               matlab.ui.control.NumericEditField
        PosicinyEditField_2Label        matlab.ui.control.Label
        PosicinxEditField               matlab.ui.control.NumericEditField
        PosicinxEditField_2Label        matlab.ui.control.Label
        VelocidadyEditField             matlab.ui.control.NumericEditField
        VelocidadxEditField_2Label_2    matlab.ui.control.Label
        VelocidadxEditField             matlab.ui.control.NumericEditField
        VelocidadxEditField_2Label      matlab.ui.control.Label
        UIAxes                          matlab.ui.control.UIAxes
        LeftPanel                       matlab.ui.container.Panel
        DimetrodelProyectilDmEditField  matlab.ui.control.NumericEditField
        DimetrodelProyectilDmLabel      matlab.ui.control.Label
        AlturamnimamEditField           matlab.ui.control.NumericEditField
        AlturamnimamEditFieldLabel      matlab.ui.control.Label
        ReiniciardatosButton            matlab.ui.control.Button
        HoldButton                      matlab.ui.control.StateButton
        dtsEditField                    matlab.ui.control.NumericEditField
        dtsEditFieldLabel               matlab.ui.control.Label
        deproyectilesaleatoriosSpinner  matlab.ui.control.Spinner
        deproyectilesaleatoriosSpinnerLabel  matlab.ui.control.Label
        EmpezarSimulacinAleatoriaButton  matlab.ui.control.Button
        EmpezarSimulacinButton          matlab.ui.control.Button
        TiempodeSimulacinsEditField     matlab.ui.control.NumericEditField
        TiempodeSimulacinsEditFieldLabel  matlab.ui.control.Label
        MasadelProyectilKgEditField     matlab.ui.control.NumericEditField
        MasadelProyectilKgEditFieldLabel  matlab.ui.control.Label
        RapidezInicialmsEditField       matlab.ui.control.NumericEditField
        RapidezInicialmsEditFieldLabel  matlab.ui.control.Label
        nguloInicialEditField           matlab.ui.control.NumericEditField
        nguloInicialEditFieldLabel      matlab.ui.control.Label
        PosicinInicialymEditField       matlab.ui.control.NumericEditField
        PosicinInicialymEditFieldLabel  matlab.ui.control.Label
        PosicinInicialxmEditField       matlab.ui.control.NumericEditField
        PosicinInicialxmEditFieldLabel  matlab.ui.control.Label
        CoeficientedeArrastreCEditField  matlab.ui.control.NumericEditField
        CoeficientedeArrastreCEditFieldLabel  matlab.ui.control.Label
        DensidaddelaireEditField        matlab.ui.control.NumericEditField
        DensidaddelaireLabel            matlab.ui.control.Label
    end



    % Callbacks that handle component events
    methods (Access = private)

        % Button pushed function: EmpezarSimulacinButton
        function EmpezarSimulacinButtonPushed(app, event)
            % Si está presionado el botón de hold, activar el hold; limpiar
            % la pantalla si no
            if app.HoldButton.Value == 1
                hold(app.UIAxes, 'on');
                track = 2;
            elseif app.HoldButton.Value == 0
                hold(app.UIAxes, 'off');
                cla(app.UIAxes)
                track = 1;
            end

            % Declarar ejes que se adaptan a la función
            app.UIAxes.YLim = [0 inf];
            
            %% Parámetros

            % Declarar condiciones iniciales usando los valores insertados
            % por el usuario

            % Aceleraciones iniciales
            ax0 = 0;
            % Gravedad
            ay0 = -9.81;

            % Velocidad inicial
            v0 = app.RapidezInicialmsEditField.Value;

            % Convertir el ángulo a radianes
            ang0 = app.nguloInicialEditField.Value*(pi/180);

            % Ambas posiciones iniciales
            x0 = app.PosicinInicialxmEditField.Value;
            y0 = app.PosicinInicialymEditField.Value;

            % Tiempo que dura la simulación si no alcanza la altura mínima
            tiempo = app.TiempodeSimulacinsEditField.Value;

            % Valores relacionados a la resistencia del aire
            D = app.DimetrodelProyectilDmEditField.Value;
            p = app.DensidaddelaireEditField.Value;
            m = app.MasadelProyectilKgEditField.Value;
            R = app.CoeficientedeArrastreCEditField.Value;

            % Guardar el modelo de resistencia del aire proporcional a la
            % velocidad al cuadrado, sin el vector velocidad en cada
            % posición.
            resistenciaSinVelocidad = 1/(2*m)*R*p*pi*D^2;

            % Declarar el primer elemento de las variables en términos de las
            % condiciones iniciales

            vx(1) = v0*cos(ang0);
            vy(1) = v0*sin(ang0);
            x(1) = x0;
            y(1) = y0;
            t(1) = 0;
            dt = app.dtsEditField.Value;

            %% Dibujar volcán :D
            % Si hold está apagado, se dibuja el volcán
            if track == 1
                x1 = linspace(-app.PosicinInicialymEditField.Value*1.2+app.PosicinInicialxmEditField.Value,app.PosicinInicialymEditField.Value*1.2+app.PosicinInicialxmEditField.Value,10000);

                % Funciones que dibujan el volcán, restringiendo el rango
                % con NaN para que se grafique solamente donde se ubica el
                % volcán.
                y1 = (1/(10*app.PosicinInicialymEditField.Value))*(x1-app.PosicinInicialxmEditField.Value).^2;
                y1(-app.PosicinInicialymEditField.Value/1.25+app.PosicinInicialxmEditField.Value > x1) = NaN;
                y1(app.PosicinInicialymEditField.Value/1.25+app.PosicinInicialxmEditField.Value < x1) = NaN;

                y2 = (1/(0.35*app.PosicinInicialymEditField.Value))*(x1-app.PosicinInicialxmEditField.Value).^2 + app.PosicinInicialymEditField.Value;
                y2(-app.PosicinInicialymEditField.Value/12+app.PosicinInicialxmEditField.Value > x1) = NaN;
                y2(app.PosicinInicialymEditField.Value/12+app.PosicinInicialxmEditField.Value < x1) = NaN;

                y3 = ((8*app.PosicinInicialymEditField.Value)/(125*exp((-4*app.PosicinInicialymEditField.Value/5)*(60/(43*app.PosicinInicialymEditField.Value))*log(257*125/(252*8)))))*exp((x1-app.PosicinInicialxmEditField.Value)*(60/(43*app.PosicinInicialymEditField.Value))*log(257*125/(252*8)));
                y3(-app.PosicinInicialymEditField.Value/1.25+app.PosicinInicialxmEditField.Value > x1) = NaN;
                y3(-app.PosicinInicialymEditField.Value/12+app.PosicinInicialxmEditField.Value < x1) = NaN;

                y4 = ((8*app.PosicinInicialymEditField.Value)/(125*exp((-4*app.PosicinInicialymEditField.Value/5)*(60/(43*app.PosicinInicialymEditField.Value))*log(257*125/(252*8)))))*exp((x1-app.PosicinInicialxmEditField.Value)*(-60/(43*app.PosicinInicialymEditField.Value))*log(257*125/(252*8)));
                y4(app.PosicinInicialymEditField.Value/12+app.PosicinInicialxmEditField.Value > x1) = NaN;
                y4(app.PosicinInicialymEditField.Value/1.25+app.PosicinInicialxmEditField.Value < x1) = NaN;

                % Hacer el plot del volcán

                plot(app.UIAxes, x1, y1, 'Color', [79/255 62/255 87/255])
                hold(app.UIAxes, 'on');
                plot(app.UIAxes, x1, y2, 'Color', [79/255 62/255 87/255])
                plot(app.UIAxes, x1, y3, 'Color', [79/255 62/255 87/255])
                plot(app.UIAxes, x1, y4, 'Color', [79/255 62/255 87/255])
                
                % Configurando variables para llenar la figura
                x2 = [x1, fliplr(x1)];
                inBetween = [y2, fliplr(y1)];
                inBetween2 = [y3, fliplr(y1)];
                inBetween3 = [y4, fliplr(y1)];

                % Remover valores que no existen en estos vectores, como
                % resultado de las discrepancias en los dominios de las
                % funciones
                x2(isnan(x2)) = [];
                inBetween(isnan(inBetween)) = 0;
                inBetween2(isnan(inBetween2)) = 0;
                inBetween3(isnan(inBetween3)) = 0;

                % Los valores que estén abajo de la curva se igualan a la
                % curva para que no se rellene lo que está debajo de la
                % curva.
                for i = 1:length(x1)
                    if inBetween(i) < y1(i)
                        inBetween(i) = y1(i);
                    end
                    if inBetween2(i) < y1(i)
                        inBetween2(i) = y1(i);
                    end
                    if inBetween3(i) < y1(i)
                        inBetween3(i) = y1(i);
                    end
                end
                
                % Hacer el relleno
                fill(app.UIAxes, x2, inBetween, [79/255 62/255 87/255], 'EdgeColor', 'none');
                fill(app.UIAxes, x2, inBetween2, [79/255 62/255 87/255], 'EdgeColor', 'none');
                fill(app.UIAxes, x2, inBetween3, [79/255 62/255 87/255], 'EdgeColor', 'none');
            end

            %% Método de Euler
            i = 1;

            while y(i) > app.AlturamnimamEditField.Value && t(i) < tiempo - 0.1

                % Usar las ecuaciones particulares de Euler para generar términos
                % consecutivos.

                vx(i+1) = vx(i) - (resistenciaSinVelocidad*sqrt(vx(i)^2 + vy(i)^2)*vx(i))*dt;
                app.VelocidadxEditField.Value = vx(i+1);

                vy(i+1) = vy(i) - (resistenciaSinVelocidad*sqrt(vx(i)^2 + vy(i)^2)*vy(i))*dt + ay0*dt;
                app.VelocidadyEditField.Value = vy(i+1);

                % Incrementar variables

                t(i+1) = t(i) + dt;
                app.TiempoEditField.Value = t(i+1);

                x(i+1) = x(i) + vx(i)*dt;
                app.PosicinxEditField.Value = x(i+1);

                y(i+1) = y(i) + vy(i)*dt;
                app.PosicinyEditField.Value = y(i+1);

                % Dibujar gráfica
                plot(app.UIAxes,x(1:i+1),y(1:i+1),"-", "Color", [240/255 102/255 37/255],"LineWidth",3)
                drawnow

                % Incrementar contador
                i = i+1;
            end
        end

        % Button pushed function: EmpezarSimulacinAleatoriaButton
        function EmpezarSimulacinAleatoriaButtonPushed(app, event)
            % Inicializar contadores, borrar gráficas previas y
            % reestablecer límites
            i = 0;
            j = 0;
            k = 0;
            hold(app.UIAxes, 'off');
            cla(app.UIAxes)
            app.UIAxes.YLim = [0 inf];

            % Ciclar la cantidad de veces que indica el usuario
            for k = 1:app.deproyectilesaleatoriosSpinner.Value
         
                %% Parámetros

                % Declarar condiciones iniciales
                resistenciaSinVelocidad = 1;
                v0 = 9999;

                % Todo se genera de la misma manera que cuando no es
                % aleatorio, con la particularidad de ser aleatorio. Para
                % evitar que la resistencia del aire cause efectos
                % inesperados a la gráfica (salir disparado hacia el eje
                % negativo), se limitaron los valores que puede tomar la
                % resistencia con prueba y error.
                while resistenciaSinVelocidad*v0^2 > 0.5*v0
                    v0 = rand*1000;
                    app.RapidezInicialmsEditField.Value = v0;
                    ax0 = 0;
                    ay0 = -9.81;
                    ang0 = rand*180*(pi/180);
                    app.nguloInicialEditField.Value = ang0/pi*180;
                    if k == 1 % Solamente la primera vez se genera una posición inicial para el volcán
                        x0 = rand*1000;
                        app.PosicinInicialxmEditField.Value = x0;
                        y0 = rand*10000;
                        app.PosicinInicialymEditField.Value = y0;
                    end
                    tiempo = 9999;
                    app.TiempodeSimulacinsEditField.Value = tiempo;
                    D = rand*10;
                    app.DimetrodelProyectilDmEditField.Value = D;
                    p = rand*10;
                    app.DensidaddelaireEditField.Value = p;
                    m = rand*10;
                    app.MasadelProyectilKgEditField.Value = m;
                    R = rand*10;
                    app.CoeficientedeArrastreCEditField.Value = R;
                    resistenciaSinVelocidad = 1/(2*m)*R*p*pi*D^2;
                end
                altmin = app.AlturamnimamEditField.Value;

                % Declarar el primer elemento de las variables en términos de las
                % condiciones iniciales

                vx(1) = v0*cos(ang0);
                vy(1) = v0*sin(ang0);
                x(1) = x0;
                y(1) = y0;
                t(1) = 0;
                dt = app.dtsEditField.Value;

                % Color generado de manera aleatoria
                color = [rand rand rand];

                %% Dibujar volcán :D (Exactamente igual que previamente)
                
                if k == 1
                    x1 = linspace(-app.PosicinInicialymEditField.Value*1.2+app.PosicinInicialxmEditField.Value,app.PosicinInicialymEditField.Value*1.2+app.PosicinInicialxmEditField.Value,10000);

                    y1 = (1/(10*app.PosicinInicialymEditField.Value))*(x1-app.PosicinInicialxmEditField.Value).^2;
                    y1(-app.PosicinInicialymEditField.Value/1.25+app.PosicinInicialxmEditField.Value > x1) = NaN;
                    y1(app.PosicinInicialymEditField.Value/1.25+app.PosicinInicialxmEditField.Value < x1) = NaN;

                    y2 = (1/(0.35*app.PosicinInicialymEditField.Value))*(x1-app.PosicinInicialxmEditField.Value).^2 + app.PosicinInicialymEditField.Value;
                    y2(-app.PosicinInicialymEditField.Value/12+app.PosicinInicialxmEditField.Value > x1) = NaN;
                    y2(app.PosicinInicialymEditField.Value/12+app.PosicinInicialxmEditField.Value < x1) = NaN;

                    y3 = ((8*app.PosicinInicialymEditField.Value)/(125*exp((-4*app.PosicinInicialymEditField.Value/5)*(60/(43*app.PosicinInicialymEditField.Value))*log(257*125/(252*8)))))*exp((x1-app.PosicinInicialxmEditField.Value)*(60/(43*app.PosicinInicialymEditField.Value))*log(257*125/(252*8)));
                    y3(-app.PosicinInicialymEditField.Value/1.25+app.PosicinInicialxmEditField.Value > x1) = NaN;
                    y3(-app.PosicinInicialymEditField.Value/12+app.PosicinInicialxmEditField.Value < x1) = NaN;

                    y4 = ((8*app.PosicinInicialymEditField.Value)/(125*exp((-4*app.PosicinInicialymEditField.Value/5)*(60/(43*app.PosicinInicialymEditField.Value))*log(257*125/(252*8)))))*exp((x1-app.PosicinInicialxmEditField.Value)*(-60/(43*app.PosicinInicialymEditField.Value))*log(257*125/(252*8)));
                    y4(app.PosicinInicialymEditField.Value/12+app.PosicinInicialxmEditField.Value > x1) = NaN;
                    y4(app.PosicinInicialymEditField.Value/1.25+app.PosicinInicialxmEditField.Value < x1) = NaN;

                    plot(app.UIAxes, x1, y1, 'Color', [79/255 62/255 87/255])
                    hold(app.UIAxes, 'on');
                    plot(app.UIAxes, x1, y2, 'Color', [79/255 62/255 87/255])
                    plot(app.UIAxes, x1, y3, 'Color', [79/255 62/255 87/255])
                    plot(app.UIAxes, x1, y4, 'Color', [79/255 62/255 87/255])
                    

                    x2 = [x1, fliplr(x1)];
                    inBetween = [y2, fliplr(y1)];
                    inBetween2 = [y3, fliplr(y1)];
                    inBetween3 = [y4, fliplr(y1)];
                    x2(isnan(x2)) = [];
                    inBetween(isnan(inBetween)) = 0;
                    inBetween2(isnan(inBetween2)) = 0;
                    inBetween3(isnan(inBetween3)) = 0;

                    for j = 1:length(x1)
                        if inBetween(j) < y1(j)
                            inBetween(j) = y1(j);
                        end
                        if inBetween2(j) < y1(j)
                            inBetween2(j) = y1(j);
                        end
                        if inBetween3(j) < y1(j)
                            inBetween3(j) = y1(j);
                        end
                    end

                    fill(app.UIAxes, x2, inBetween, [79/255 62/255 87/255], 'EdgeColor', 'none');
                    fill(app.UIAxes, x2, inBetween2, [79/255 62/255 87/255], 'EdgeColor', 'none');
                    fill(app.UIAxes, x2, inBetween3, [79/255 62/255 87/255], 'EdgeColor', 'none');
                end

                %% Método de Euler (Exactamente igual que anteriormente, pero con el color distinto)
                i = 1;

                while y(i) > altmin && t(i) < tiempo - 0.1

                    % Usar las ecuaciones particulares de Euler para generar términos
                    % consecutivos

                    vx(i+1) = vx(i) - (resistenciaSinVelocidad*sqrt(vx(i)^2 + vy(i)^2)*vx(i))*dt;
                    app.VelocidadxEditField.Value = vx(i+1);

                    vy(i+1) = vy(i) - (resistenciaSinVelocidad*sqrt(vx(i)^2 + vy(i)^2)*vy(i))*dt + ay0*dt;
                    app.VelocidadyEditField.Value = vy(i+1);

                    % Incrementar variables

                    t(i+1) = t(i) + dt;
                    app.TiempoEditField.Value = t(i+1);

                    x(i+1) = x(i) + vx(i)*dt;
                    app.PosicinxEditField.Value = x(i+1);

                    y(i+1) = y(i) + vy(i)*dt;
                    app.PosicinyEditField.Value = y(i+1);

                    % Dibujar gráfica
                    plot(app.UIAxes,x(1:i+1),y(1:i+1),"-", "Color", color,"LineWidth",3)
                    drawnow

                    i = i+1;
                end
                
            end
            app.UIAxes.YLim = [0 inf];
        end

        % Button pushed function: ReiniciardatosButton
        function ReiniciardatosButtonPushed(app, event)
            %% Parámetros (con sus explicaciones)

            % Reiniciar condiciones iniciales

            app.DimetrodelProyectilDmEditField.Value = 0.064;
            % D = 0.064m; 64mm es el tamaño mínimo para que un fragmento de
            % roca se considere una "bomba volcánica", las cuales
            % representan el riesgo más alto para los habitantes de zonas
            % volcánicas (Mahmut, 2023; Gobierno de España, s.f). Entonces,
            % se utilizó este valor para el diámetro del proyectil ya que
            % esta simulación busca modelar condiciones potencialmente
            % fatales para la población.

            app.RapidezInicialmsEditField.Value = 111;
            % v0 = 111 m/s; aunque en modelos experimentales se registren
            % velocidades de entre 25 m/s y 60 m/s, en erupciones de la
            % vida real se han registrado velocidades iniciales mucho
            % mayores. De manera concreta, en la erupción del Monte Santa
            % Helena en 1980, se registró una rapidez de 111 m/s para los
            % fragmentos de algunos centímetros de diámetro (Graettinger & 
            % Krippner, 2016). Dado que el valor del diámetro en este modelo
            % es de 64mm, o 6.4cm, se justifica el uso de este valor para
            % la rapidez en la simulación.

            app.nguloInicialEditField.Value = 45;
            % θ0 = 45°; es el ángulo ideal para un lanzamiento, de acuerdo
            % a las propiedades de los vectores: sin (θ0) = cos (θ0) en
            % este ángulo. Esto exhibe el mayor alcance posible de los
            % fragmentos de la simulación, por lo que la distancia a la que
            % llegan las rocas debe representar el mínimo absoluto al que
            % se debe encontrar una persona para asegurar su seguridad.

            app.PosicinInicialxmEditField.Value = 0;
            % x0 = 0m; facilita la comprensión de la posición final en x,
            % ya que se puede tomar como una distancia desde el volcán.

            app.PosicinInicialymEditField.Value = 5393;
            % y0 = 5393m; esta es la altura del Popocatépetl (Smithsonian 
            % Institution, 2023), que, de acuerdo a la NASA (2016), es uno 
            % de los volcanes más activos de México, contribuyendo a la
            % validez de esta simulación en un escenario real.

            app.AlturamnimamEditField.Value = 2600;
            % ymin = 2600m; esta es la altura media de San Nicolás de los
            % Ranchos, uno de los poblados con mayor cercanía al
            % Popocatépetl (INEGI, 2009).
     
            app.DensidaddelaireEditField.Value = 0.63703;
            % ρ = 0.63703kg/m^3; esta es la densidad del aire en las 
            % condiciones presentes en la cumbre del Popocatépetl.
            % Por medio de la calculadora en
            % "https://www.omnicalculator.com/physics/air-density" 
            % (Czernia & Szyk, 2023), se obtuvo este valor al insertar la 
            % presión del aire y la temperatura del aire.
            % 
            % Estos datos se obtuvieron a través de los siguientes medios:
            % Según la Conevyt (s.f.), la temperatura del aire a 5000m es 
            % de aproximadamente -17.5°C, es decir, 255.65K; se usó -20°C 
            % (T = 253.15K) para tomar en cuenta la diferencia entre 5000m
            % y 5393m, la altura del Popocatépetl. Al usar la calculadora en
            % "https://www.mide.com/air-pressure-at-altitude-calculator",
            % se encontró que la presión del aire seco en estas condiciones
            % de altura y temperatura es de P_d = 46291.08Pa (Midé, 2019).
            % 
            % Finalmente, se insertaron estos datos en la calculadora y se
            % obtuvo la densidad del aire correspondiente.

            app.MasadelProyectilKgEditField.Value = 1;
            % m = 1kg; según mediciones de campo de explosiones del volcán
            % Stromboli en Italia realizadas por Harris et al. (2013), se
            % determinó que las bombas volcánicas tienen masas de entre 1 y
            % 9kg. Se usó el límite inferior de este rango en la simulación
            % ya que es más común que se expulsen fragmentos más pequeños.

            app.CoeficientedeArrastreCEditField.Value = 0.5;
            % C = 0.50; de acuerdo a The Engineering Toolbox (2004), el
            % valor del coeficiente de arrastre depende de factores como el
            % Número de Reynolds y qué tan liso es el objeto. Para una
            % esfera, el sitio clasifica su coeficiente de arrastre como
            % 0.50, justificando su uso en esta simulación.
        
            app.dtsEditField.Value = 0.1;
            % dt = 0.1s; permite un gráfico suficientemente preciso, 
            % mientras se limita el poder computacional requerido para su 
            % generación. En este sentido, el resultado se acerca a lo que 
            % un método analítico, en lugar de uno numérico como el método 
            % de Euler, podría proporcionar para la trayectoria del objeto.

            app.TiempodeSimulacinsEditField.Value = 53.4;
            % t = 53.4s; tiempo que dura la simulación cuando se utilizan
            % los valores predeterminados.

            %{
            Referencias:

Conevyt. (s.f.). La atmósfera. http://www.cursosinea.conevyt.org.mx/
    cursos/operaciones_avanzadas_v2/main/u_1/u1_act2.htm
Czernia, D. & Szyk, B. (2023, junio 5). Air Density Calculator. Omni
    Calculator. https://www.omnicalculator.com/physics/air-density
Gobierno de España. (s.f.). Volcanes. 
    https://www.proteccioncivil.es/coordinacion/gestion-riesgos/geologicos/volcanes
Graettinger, A. & Krippner, J. (2016, febrero). How fast is volcano-fast? 
    In the Company of Volcanoes. https://inthecompanyofvolcanoes.blogspot.com/2016/02/how-fast-is-volcano-fast.html
Harris, A.J.L., Delle Donne, D., Dehn, J., Ripepe, M. & Worden, A.K. 
    (2013). Volcanic plume and bomb field masses from thermal infrared 
    camera imagery. Earth and Planetary Science Letters. Volume 365. 
    pp 75-85. https://doi.org/10.1016/j.epsl.2013.01.004
INEGI. (2009). Prontuario de información geográfica municipal de los
    Estados Unidos Mexicanos San Nicolás de los Ranchos, Puebla. 
    https://web.archive.org/web/20161003232004/http://www3.inegi.org.mx/
    sistemas/mexicocifras/datos-geograficos/21/21138.pdf
Mahmut, M. (2023, agosto 15). Volcanic Bomb. Geology Science. 
    https://geologyscience.com/rocks/volcanic-bomb/
Midé. (2019). Air Pressure at Altitude Calculator. https://www.mide.com/
    air-pressure-at-altitude-calculator
NASA. (2016, enero 25). Volcanic Activity at Popocatépetl. 
    https://earthobservatory.nasa.gov/images/87414/volcanic-activity-at-
    popocatepetl
Smithsonian Institution. (2023). Popocatépetl. 
    https://volcano.si.edu/volcano.cfm?vn=341090
The Engineering Toolbox. (2004). Drag Coefficient. 
    https://www.engineeringtoolbox.com/drag-coefficient-d_627.html

            %}

        end
    end

    % Component initialization
    methods (Access = private)

        % Create UIFigure and components
        function createComponents(app)

            % Create UIFigure and hide until all components are created
            app.UIFigure = uifigure('Visible', 'off');
            app.UIFigure.Position = [98 98 640 480];
            app.UIFigure.Name = 'MATLAB App';

            % Create LeftPanel
            app.LeftPanel = uipanel(app.UIFigure);
            app.LeftPanel.BorderWidth = 3;
            app.LeftPanel.BackgroundColor = [0.4 0.4706 0.5216];
            app.LeftPanel.FontSize = 8;
            app.LeftPanel.Position = [1 1 178 480];

            % Create DensidaddelaireLabel
            app.DensidaddelaireLabel = uilabel(app.LeftPanel);
            app.DensidaddelaireLabel.HorizontalAlignment = 'right';
            app.DensidaddelaireLabel.FontSize = 8;
            app.DensidaddelaireLabel.FontWeight = 'bold';
            app.DensidaddelaireLabel.FontColor = [1 1 1];
            app.DensidaddelaireLabel.Position = [17 418 96 22];
            app.DensidaddelaireLabel.Text = 'Densidad del aire (ρ)';

            % Create DensidaddelaireEditField
            app.DensidaddelaireEditField = uieditfield(app.LeftPanel, 'numeric');
            app.DensidaddelaireEditField.Limits = [0 Inf];
            app.DensidaddelaireEditField.HorizontalAlignment = 'center';
            app.DensidaddelaireEditField.FontSize = 8;
            app.DensidaddelaireEditField.BackgroundColor = [0.8706 0.8902 0.9412];
            app.DensidaddelaireEditField.Position = [128 418 40 22];
            app.DensidaddelaireEditField.Value = 0.63703;

            % Create CoeficientedeArrastreCEditFieldLabel
            app.CoeficientedeArrastreCEditFieldLabel = uilabel(app.LeftPanel);
            app.CoeficientedeArrastreCEditFieldLabel.HorizontalAlignment = 'right';
            app.CoeficientedeArrastreCEditFieldLabel.FontSize = 8;
            app.CoeficientedeArrastreCEditFieldLabel.FontWeight = 'bold';
            app.CoeficientedeArrastreCEditFieldLabel.FontColor = [1 1 1];
            app.CoeficientedeArrastreCEditFieldLabel.Position = [7 390 106 22];
            app.CoeficientedeArrastreCEditFieldLabel.Text = 'Coeficiente de Arrastre (C)';

            % Create CoeficientedeArrastreCEditField
            app.CoeficientedeArrastreCEditField = uieditfield(app.LeftPanel, 'numeric');
            app.CoeficientedeArrastreCEditField.Limits = [0 Inf];
            app.CoeficientedeArrastreCEditField.HorizontalAlignment = 'center';
            app.CoeficientedeArrastreCEditField.FontSize = 8;
            app.CoeficientedeArrastreCEditField.BackgroundColor = [0.8706 0.8902 0.9412];
            app.CoeficientedeArrastreCEditField.Position = [128 390 40 22];
            app.CoeficientedeArrastreCEditField.Value = 0.5;

            % Create PosicinInicialxmEditFieldLabel
            app.PosicinInicialxmEditFieldLabel = uilabel(app.LeftPanel);
            app.PosicinInicialxmEditFieldLabel.HorizontalAlignment = 'right';
            app.PosicinInicialxmEditFieldLabel.FontSize = 8;
            app.PosicinInicialxmEditFieldLabel.FontWeight = 'bold';
            app.PosicinInicialxmEditFieldLabel.FontColor = [1 1 1];
            app.PosicinInicialxmEditFieldLabel.Position = [28 362 85 22];
            app.PosicinInicialxmEditFieldLabel.Text = 'Posición Inicial x (m)';

            % Create PosicinInicialxmEditField
            app.PosicinInicialxmEditField = uieditfield(app.LeftPanel, 'numeric');
            app.PosicinInicialxmEditField.Limits = [0 Inf];
            app.PosicinInicialxmEditField.HorizontalAlignment = 'center';
            app.PosicinInicialxmEditField.FontSize = 8;
            app.PosicinInicialxmEditField.BackgroundColor = [0.8706 0.8902 0.9412];
            app.PosicinInicialxmEditField.Position = [128 362 40 22];

            % Create PosicinInicialymEditFieldLabel
            app.PosicinInicialymEditFieldLabel = uilabel(app.LeftPanel);
            app.PosicinInicialymEditFieldLabel.HorizontalAlignment = 'right';
            app.PosicinInicialymEditFieldLabel.FontSize = 8;
            app.PosicinInicialymEditFieldLabel.FontWeight = 'bold';
            app.PosicinInicialymEditFieldLabel.FontColor = [1 1 1];
            app.PosicinInicialymEditFieldLabel.Position = [28 334 85 22];
            app.PosicinInicialymEditFieldLabel.Text = 'Posición Inicial y (m)';

            % Create PosicinInicialymEditField
            app.PosicinInicialymEditField = uieditfield(app.LeftPanel, 'numeric');
            app.PosicinInicialymEditField.HorizontalAlignment = 'center';
            app.PosicinInicialymEditField.FontSize = 8;
            app.PosicinInicialymEditField.BackgroundColor = [0.8706 0.8902 0.9412];
            app.PosicinInicialymEditField.Position = [128 334 40 22];
            app.PosicinInicialymEditField.Value = 5393;

            % Create nguloInicialEditFieldLabel
            app.nguloInicialEditFieldLabel = uilabel(app.LeftPanel);
            app.nguloInicialEditFieldLabel.HorizontalAlignment = 'right';
            app.nguloInicialEditFieldLabel.FontSize = 8;
            app.nguloInicialEditFieldLabel.FontWeight = 'bold';
            app.nguloInicialEditFieldLabel.FontColor = [1 1 1];
            app.nguloInicialEditFieldLabel.Position = [45 306 68 22];
            app.nguloInicialEditFieldLabel.Text = 'Ángulo Inicial (°)';

            % Create nguloInicialEditField
            app.nguloInicialEditField = uieditfield(app.LeftPanel, 'numeric');
            app.nguloInicialEditField.LowerLimitInclusive = 'off';
            app.nguloInicialEditField.UpperLimitInclusive = 'off';
            app.nguloInicialEditField.Limits = [0 180];
            app.nguloInicialEditField.HorizontalAlignment = 'center';
            app.nguloInicialEditField.FontSize = 8;
            app.nguloInicialEditField.BackgroundColor = [0.8706 0.8902 0.9412];
            app.nguloInicialEditField.Position = [128 306 40 22];
            app.nguloInicialEditField.Value = 45;

            % Create RapidezInicialmsEditFieldLabel
            app.RapidezInicialmsEditFieldLabel = uilabel(app.LeftPanel);
            app.RapidezInicialmsEditFieldLabel.HorizontalAlignment = 'right';
            app.RapidezInicialmsEditFieldLabel.FontSize = 8;
            app.RapidezInicialmsEditFieldLabel.FontWeight = 'bold';
            app.RapidezInicialmsEditFieldLabel.FontColor = [1 1 1];
            app.RapidezInicialmsEditFieldLabel.Position = [30 278 83 22];
            app.RapidezInicialmsEditFieldLabel.Text = 'Rapidez Inicial (m/s)';

            % Create RapidezInicialmsEditField
            app.RapidezInicialmsEditField = uieditfield(app.LeftPanel, 'numeric');
            app.RapidezInicialmsEditField.LowerLimitInclusive = 'off';
            app.RapidezInicialmsEditField.Limits = [0 Inf];
            app.RapidezInicialmsEditField.HorizontalAlignment = 'center';
            app.RapidezInicialmsEditField.FontSize = 8;
            app.RapidezInicialmsEditField.BackgroundColor = [0.8706 0.8902 0.9412];
            app.RapidezInicialmsEditField.Position = [128 278 40 22];
            app.RapidezInicialmsEditField.Value = 111;

            % Create MasadelProyectilKgEditFieldLabel
            app.MasadelProyectilKgEditFieldLabel = uilabel(app.LeftPanel);
            app.MasadelProyectilKgEditFieldLabel.HorizontalAlignment = 'right';
            app.MasadelProyectilKgEditFieldLabel.FontSize = 8;
            app.MasadelProyectilKgEditFieldLabel.FontWeight = 'bold';
            app.MasadelProyectilKgEditFieldLabel.FontColor = [1 1 1];
            app.MasadelProyectilKgEditFieldLabel.Position = [17 250 96 22];
            app.MasadelProyectilKgEditFieldLabel.Text = 'Masa del Proyectil (Kg)';

            % Create MasadelProyectilKgEditField
            app.MasadelProyectilKgEditField = uieditfield(app.LeftPanel, 'numeric');
            app.MasadelProyectilKgEditField.LowerLimitInclusive = 'off';
            app.MasadelProyectilKgEditField.Limits = [0 Inf];
            app.MasadelProyectilKgEditField.HorizontalAlignment = 'center';
            app.MasadelProyectilKgEditField.FontSize = 8;
            app.MasadelProyectilKgEditField.BackgroundColor = [0.8706 0.8902 0.9412];
            app.MasadelProyectilKgEditField.Position = [128 250 40 22];
            app.MasadelProyectilKgEditField.Value = 1;

            % Create TiempodeSimulacinsEditFieldLabel
            app.TiempodeSimulacinsEditFieldLabel = uilabel(app.LeftPanel);
            app.TiempodeSimulacinsEditFieldLabel.HorizontalAlignment = 'right';
            app.TiempodeSimulacinsEditFieldLabel.FontSize = 8;
            app.TiempodeSimulacinsEditFieldLabel.FontWeight = 'bold';
            app.TiempodeSimulacinsEditFieldLabel.FontColor = [1 1 1];
            app.TiempodeSimulacinsEditFieldLabel.Position = [11 222 102 22];
            app.TiempodeSimulacinsEditFieldLabel.Text = 'Tiempo de Simulación (s)';

            % Create TiempodeSimulacinsEditField
            app.TiempodeSimulacinsEditField = uieditfield(app.LeftPanel, 'numeric');
            app.TiempodeSimulacinsEditField.LowerLimitInclusive = 'off';
            app.TiempodeSimulacinsEditField.Limits = [0 Inf];
            app.TiempodeSimulacinsEditField.HorizontalAlignment = 'center';
            app.TiempodeSimulacinsEditField.FontSize = 8;
            app.TiempodeSimulacinsEditField.BackgroundColor = [0.8706 0.8902 0.9412];
            app.TiempodeSimulacinsEditField.Position = [128 222 40 22];
            app.TiempodeSimulacinsEditField.Value = 53.4;

            % Create EmpezarSimulacinButton
            app.EmpezarSimulacinButton = uibutton(app.LeftPanel, 'push');
            app.EmpezarSimulacinButton.ButtonPushedFcn = createCallbackFcn(app, @EmpezarSimulacinButtonPushed, true);
            app.EmpezarSimulacinButton.IconAlignment = 'center';
            app.EmpezarSimulacinButton.BackgroundColor = [0.4706 0.6941 0.8392];
            app.EmpezarSimulacinButton.FontSize = 9;
            app.EmpezarSimulacinButton.FontWeight = 'bold';
            app.EmpezarSimulacinButton.Position = [37 89 100 22];
            app.EmpezarSimulacinButton.Text = 'Empezar Simulación';

            % Create EmpezarSimulacinAleatoriaButton
            app.EmpezarSimulacinAleatoriaButton = uibutton(app.LeftPanel, 'push');
            app.EmpezarSimulacinAleatoriaButton.ButtonPushedFcn = createCallbackFcn(app, @EmpezarSimulacinAleatoriaButtonPushed, true);
            app.EmpezarSimulacinAleatoriaButton.IconAlignment = 'center';
            app.EmpezarSimulacinAleatoriaButton.BackgroundColor = [0.9804 0.3922 0.3922];
            app.EmpezarSimulacinAleatoriaButton.FontSize = 9;
            app.EmpezarSimulacinAleatoriaButton.FontWeight = 'bold';
            app.EmpezarSimulacinAleatoriaButton.Position = [16 7 142 22];
            app.EmpezarSimulacinAleatoriaButton.Text = 'Empezar Simulación Aleatoria';

            % Create deproyectilesaleatoriosSpinnerLabel
            app.deproyectilesaleatoriosSpinnerLabel = uilabel(app.LeftPanel);
            app.deproyectilesaleatoriosSpinnerLabel.BackgroundColor = [0.4 0.4706 0.5216];
            app.deproyectilesaleatoriosSpinnerLabel.HorizontalAlignment = 'right';
            app.deproyectilesaleatoriosSpinnerLabel.FontSize = 10;
            app.deproyectilesaleatoriosSpinnerLabel.FontWeight = 'bold';
            app.deproyectilesaleatoriosSpinnerLabel.FontColor = [1 1 1];
            app.deproyectilesaleatoriosSpinnerLabel.Position = [21 57 131 22];
            app.deproyectilesaleatoriosSpinnerLabel.Text = '# de proyectiles aleatorios';

            % Create deproyectilesaleatoriosSpinner
            app.deproyectilesaleatoriosSpinner = uispinner(app.LeftPanel);
            app.deproyectilesaleatoriosSpinner.Limits = [1 100];
            app.deproyectilesaleatoriosSpinner.FontSize = 10;
            app.deproyectilesaleatoriosSpinner.BackgroundColor = [0.8706 0.8902 0.9412];
            app.deproyectilesaleatoriosSpinner.Position = [59 34 58 22];
            app.deproyectilesaleatoriosSpinner.Value = 1;

            % Create dtsEditFieldLabel
            app.dtsEditFieldLabel = uilabel(app.LeftPanel);
            app.dtsEditFieldLabel.HorizontalAlignment = 'right';
            app.dtsEditFieldLabel.FontSize = 8;
            app.dtsEditFieldLabel.FontWeight = 'bold';
            app.dtsEditFieldLabel.FontColor = [1 1 1];
            app.dtsEditFieldLabel.Position = [88 167 25 22];
            app.dtsEditFieldLabel.Text = 'dt (s)';

            % Create dtsEditField
            app.dtsEditField = uieditfield(app.LeftPanel, 'numeric');
            app.dtsEditField.LowerLimitInclusive = 'off';
            app.dtsEditField.Limits = [0 Inf];
            app.dtsEditField.HorizontalAlignment = 'center';
            app.dtsEditField.FontSize = 8;
            app.dtsEditField.BackgroundColor = [0.8706 0.8902 0.9412];
            app.dtsEditField.Position = [128 167 40 22];
            app.dtsEditField.Value = 0.1;

            % Create HoldButton
            app.HoldButton = uibutton(app.LeftPanel, 'state');
            app.HoldButton.Text = 'Hold';
            app.HoldButton.BackgroundColor = [0.7098 0.9608 0.3843];
            app.HoldButton.FontSize = 10;
            app.HoldButton.FontAngle = 'italic';
            app.HoldButton.Position = [21 166 53 23];

            % Create ReiniciardatosButton
            app.ReiniciardatosButton = uibutton(app.LeftPanel, 'push');
            app.ReiniciardatosButton.ButtonPushedFcn = createCallbackFcn(app, @ReiniciardatosButtonPushed, true);
            app.ReiniciardatosButton.BackgroundColor = [0.8627 0.4902 1];
            app.ReiniciardatosButton.FontSize = 10;
            app.ReiniciardatosButton.Position = [8 140 79 20];
            app.ReiniciardatosButton.Text = 'Reiniciar datos';

            % Create AlturamnimamEditFieldLabel
            app.AlturamnimamEditFieldLabel = uilabel(app.LeftPanel);
            app.AlturamnimamEditFieldLabel.HorizontalAlignment = 'right';
            app.AlturamnimamEditFieldLabel.FontSize = 8;
            app.AlturamnimamEditFieldLabel.FontWeight = 'bold';
            app.AlturamnimamEditFieldLabel.FontColor = [1 1 1];
            app.AlturamnimamEditFieldLabel.Position = [40 194 73 22];
            app.AlturamnimamEditFieldLabel.Text = 'Altura mínima (m)';

            % Create AlturamnimamEditField
            app.AlturamnimamEditField = uieditfield(app.LeftPanel, 'numeric');
            app.AlturamnimamEditField.LowerLimitInclusive = 'off';
            app.AlturamnimamEditField.HorizontalAlignment = 'center';
            app.AlturamnimamEditField.FontSize = 8;
            app.AlturamnimamEditField.BackgroundColor = [0.8706 0.8902 0.9412];
            app.AlturamnimamEditField.Position = [128 194 40 22];
            app.AlturamnimamEditField.Value = 2600;

            % Create DimetrodelProyectilDmLabel
            app.DimetrodelProyectilDmLabel = uilabel(app.LeftPanel);
            app.DimetrodelProyectilDmLabel.HorizontalAlignment = 'right';
            app.DimetrodelProyectilDmLabel.FontSize = 8;
            app.DimetrodelProyectilDmLabel.FontWeight = 'bold';
            app.DimetrodelProyectilDmLabel.FontColor = [1 1 1];
            app.DimetrodelProyectilDmLabel.Position = [2 446 112 22];
            app.DimetrodelProyectilDmLabel.Text = 'Diámetro del Proyectil (D,m)';

            % Create DimetrodelProyectilDmEditField
            app.DimetrodelProyectilDmEditField = uieditfield(app.LeftPanel, 'numeric');
            app.DimetrodelProyectilDmEditField.LowerLimitInclusive = 'off';
            app.DimetrodelProyectilDmEditField.Limits = [0 Inf];
            app.DimetrodelProyectilDmEditField.HorizontalAlignment = 'center';
            app.DimetrodelProyectilDmEditField.FontSize = 8;
            app.DimetrodelProyectilDmEditField.BackgroundColor = [0.8706 0.8902 0.9412];
            app.DimetrodelProyectilDmEditField.Position = [128 446 40 22];
            app.DimetrodelProyectilDmEditField.Value = 0.064;

            % Create RightPanel
            app.RightPanel = uipanel(app.UIFigure);
            app.RightPanel.BorderWidth = 3;
            app.RightPanel.BackgroundColor = [0.7098 0.7882 0.851];
            app.RightPanel.Position = [178 1 462 480];

            % Create UIAxes
            app.UIAxes = uiaxes(app.RightPanel);
            title(app.UIAxes, 'Posición del Proyectil')
            xlabel(app.UIAxes, 'x(t) [m]')
            ylabel(app.UIAxes, 'y(t) [m]')
            zlabel(app.UIAxes, 'Z')
            app.UIAxes.Position = [11 74 441 401];

            % Create VelocidadxEditField_2Label
            app.VelocidadxEditField_2Label = uilabel(app.RightPanel);
            app.VelocidadxEditField_2Label.HorizontalAlignment = 'right';
            app.VelocidadxEditField_2Label.FontSize = 10;
            app.VelocidadxEditField_2Label.FontWeight = 'bold';
            app.VelocidadxEditField_2Label.Position = [40 37 60 22];
            app.VelocidadxEditField_2Label.Text = 'Velocidad x';

            % Create VelocidadxEditField
            app.VelocidadxEditField = uieditfield(app.RightPanel, 'numeric');
            app.VelocidadxEditField.ValueDisplayFormat = '%.3f';
            app.VelocidadxEditField.Editable = 'off';
            app.VelocidadxEditField.HorizontalAlignment = 'center';
            app.VelocidadxEditField.FontSize = 10;
            app.VelocidadxEditField.Position = [108 36 61 22];

            % Create VelocidadxEditField_2Label_2
            app.VelocidadxEditField_2Label_2 = uilabel(app.RightPanel);
            app.VelocidadxEditField_2Label_2.HorizontalAlignment = 'right';
            app.VelocidadxEditField_2Label_2.FontSize = 10;
            app.VelocidadxEditField_2Label_2.FontWeight = 'bold';
            app.VelocidadxEditField_2Label_2.Position = [40 8 60 22];
            app.VelocidadxEditField_2Label_2.Text = 'Velocidad y';

            % Create VelocidadyEditField
            app.VelocidadyEditField = uieditfield(app.RightPanel, 'numeric');
            app.VelocidadyEditField.ValueDisplayFormat = '%.3f';
            app.VelocidadyEditField.Editable = 'off';
            app.VelocidadyEditField.HorizontalAlignment = 'center';
            app.VelocidadyEditField.FontSize = 10;
            app.VelocidadyEditField.Position = [108 7 61 22];

            % Create PosicinxEditField_2Label
            app.PosicinxEditField_2Label = uilabel(app.RightPanel);
            app.PosicinxEditField_2Label.HorizontalAlignment = 'right';
            app.PosicinxEditField_2Label.FontSize = 10;
            app.PosicinxEditField_2Label.FontWeight = 'bold';
            app.PosicinxEditField_2Label.Position = [188 37 55 22];
            app.PosicinxEditField_2Label.Text = 'Posición x';

            % Create PosicinxEditField
            app.PosicinxEditField = uieditfield(app.RightPanel, 'numeric');
            app.PosicinxEditField.ValueDisplayFormat = '%.3f';
            app.PosicinxEditField.Editable = 'off';
            app.PosicinxEditField.HorizontalAlignment = 'center';
            app.PosicinxEditField.FontSize = 10;
            app.PosicinxEditField.Position = [251 37 57 22];

            % Create PosicinyEditField_2Label
            app.PosicinyEditField_2Label = uilabel(app.RightPanel);
            app.PosicinyEditField_2Label.HorizontalAlignment = 'right';
            app.PosicinyEditField_2Label.FontSize = 10;
            app.PosicinyEditField_2Label.FontWeight = 'bold';
            app.PosicinyEditField_2Label.Position = [188 8 55 22];
            app.PosicinyEditField_2Label.Text = 'Posición y';

            % Create PosicinyEditField
            app.PosicinyEditField = uieditfield(app.RightPanel, 'numeric');
            app.PosicinyEditField.ValueDisplayFormat = '%.3f';
            app.PosicinyEditField.Editable = 'off';
            app.PosicinyEditField.HorizontalAlignment = 'center';
            app.PosicinyEditField.FontSize = 10;
            app.PosicinyEditField.Position = [251 7 57 22];

            % Create TiempoEditFieldLabel
            app.TiempoEditFieldLabel = uilabel(app.RightPanel);
            app.TiempoEditFieldLabel.HorizontalAlignment = 'right';
            app.TiempoEditFieldLabel.FontSize = 10;
            app.TiempoEditFieldLabel.FontWeight = 'bold';
            app.TiempoEditFieldLabel.Position = [325 22 40 22];
            app.TiempoEditFieldLabel.Text = 'Tiempo';

            % Create TiempoEditField
            app.TiempoEditField = uieditfield(app.RightPanel, 'numeric');
            app.TiempoEditField.Limits = [0 Inf];
            app.TiempoEditField.ValueDisplayFormat = '%.1f';
            app.TiempoEditField.Editable = 'off';
            app.TiempoEditField.HorizontalAlignment = 'center';
            app.TiempoEditField.FontSize = 10;
            app.TiempoEditField.Position = [373 22 39 22];

            % Show the figure after all components are created
            app.UIFigure.Visible = 'on';
        end
    end

    % App creation and deletion
    methods (Access = public)

        % Construct app
        function app = Motor_de_Simulacion_del_Movimiento_exported

            % Create UIFigure and components
            createComponents(app)

            % Register the app with App Designer
            registerApp(app, app.UIFigure)

            if nargout == 0
                clear app
            end
        end

        % Code that executes before app deletion
        function delete(app)

            % Delete UIFigure when app is deleted
            delete(app.UIFigure)
        end
    end
end