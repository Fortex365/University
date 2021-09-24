using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Data;
using System.Windows.Documents;
using System.Windows.Input;
using System.Windows.Media;
using System.Windows.Media.Imaging;
using System.Windows.Navigation;
using System.Windows.Shapes;

namespace Grafika
{
    /// <summary>
    /// Interaction logic for MainWindow.xaml
    /// </summary>
    public partial class MainWindow : Window
    {
        private enum cShapes { Line, Square, Polygon, Circle}
        private cShapes currentShape = cShapes.Line;

        private SolidColorBrush currentColor = Brushes.Black;

        private Polygon currentlyDrawnPolygon = new Polygon() {};

        public MainWindow()
        {
            InitializeComponent();
        }

        private void LineButton_Click(object sender, RoutedEventArgs e)
        {
            currentShape = cShapes.Line;
        }

        private void SquareButton_Click(object sender, RoutedEventArgs e)
        {
            currentShape = cShapes.Square;
        }

        private void PolygonButton_Click(object sender, RoutedEventArgs e)
        {
            currentShape = cShapes.Polygon;
            currentlyDrawnPolygon = new Polygon() {StrokeThickness=5};
            canvas.Children.Add(currentlyDrawnPolygon);
        }

        private void CircleButton_Click(object sender, RoutedEventArgs e)
        {
            currentShape = cShapes.Circle;
        }

        private Point startClick;
        private Point endClick;

        private void canvas_MouseDown(object sender, MouseButtonEventArgs e)
        {
            startClick = e.GetPosition(this);
            if (currentShape == cShapes.Polygon)
            {
                DrawPolygon();
            }
        }

        private void canvas_MouseUp(object sender, MouseButtonEventArgs e)
        {
            switch (currentShape)
            {
                case cShapes.Line:
                    DrawLine();
                    break;
                case cShapes.Square:
                    DrawSquare();
                    break;
                case cShapes.Polygon:
                    DrawPolygon();
                    break;
                case cShapes.Circle:
                    DrawCircle();
                    break;
                default:
                    return;
            }
        }

        private void canvas_MouseMove(object sender, MouseEventArgs e)
        {
            if(e.LeftButton == MouseButtonState.Pressed)
            {
                endClick = e.GetPosition(this);
            }
        }

        private void DrawLine()
        {
            Line l = new Line()
            { 
                X1 = startClick.X,
                Y1 = startClick.Y,
                X2 = endClick.X,
                Y2 = endClick.Y,
                StrokeThickness = 5
            };
            l.Stroke = currentColor;
            canvas.Children.Add(l);
        }

        private void DrawCircle()
        {
            Ellipse e = new Ellipse()
            {
                Stroke = Brushes.Black,
                StrokeThickness = 5,
                Height = 10,
                Width = 10,
            };

            if(endClick.X > startClick.X)
            {
                e.SetValue(Canvas.LeftProperty, startClick.X);
                e.Width = endClick.X - startClick.X;
            }
            else
            {
                e.SetValue(Canvas.LeftProperty, endClick.X);
                e.Width = startClick.X - endClick.X;
            }
            if(endClick.Y >= startClick.Y)
            {
                e.SetValue(Canvas.TopProperty, startClick.Y - 5);
                e.Height = endClick.Y - startClick.Y;
            }
            else
            {
                e.SetValue(Canvas.TopProperty, endClick.Y - 5);
                e.Height = startClick.X - endClick.X;
            }
            e.Stroke = currentColor;
            canvas.Children.Add(e);
        }

        private void DrawSquare()
        {
            Rectangle r = new Rectangle()
            {
                Stroke = Brushes.Black,
                StrokeThickness = 5,
                Height = 10,
                Width = 10,
            };
            if (endClick.X > startClick.X)
            {
                r.SetValue(Canvas.LeftProperty, startClick.X);
                r.Width = endClick.X - startClick.X;
            }
            else
            {
                r.SetValue(Canvas.LeftProperty, endClick.X);
                r.Width = startClick.X - endClick.X;
            }
            if (endClick.Y >= startClick.Y)
            {
                r.SetValue(Canvas.TopProperty, startClick.Y - 5);
                r.Height = endClick.Y - startClick.Y;
            }
            else
            {
                r.SetValue(Canvas.TopProperty, endClick.Y - 5);
                r.Height = startClick.X - endClick.X;
            }
            r.Stroke = currentColor;
            canvas.Children.Add(r);
        }

        private void DrawPolygon()
        {
            currentlyDrawnPolygon.Stroke = currentColor;
            currentlyDrawnPolygon.Points.Add(startClick);
        }

        private void Black_Click(object sender, RoutedEventArgs e)
        {
            currentColor = Brushes.Black;
        }

        private void Red_Click(object sender, RoutedEventArgs e)
        {
            currentColor = Brushes.Red;
        }

        private void Green_Click(object sender, RoutedEventArgs e)
        {
            currentColor = Brushes.Green;
        }

        private void Blue_Click(object sender, RoutedEventArgs e)
        {
            currentColor = Brushes.Blue;
        }

        private void Button_Click(object sender, RoutedEventArgs e)
        {
            try
            {
                RenderTargetBitmap rtb = new RenderTargetBitmap((int)canvas.RenderSize.Width,
                (int)canvas.RenderSize.Height, 96, 96, PixelFormats.Default);
                rtb.Render(canvas);
                BitmapEncoder encoder = new PngBitmapEncoder();
                encoder.Frames.Add(BitmapFrame.Create(rtb));
                using (var fs = File.OpenWrite(@"C:\Users\Luky\Data\School\Vysoká\ZP4_CS\Grafika\canvas.png"))
                {
                    encoder.Save(fs);
                }
            }
            catch
            {
                MessageBox.Show("Nepovedlo se ulozit soubor");
            }
        }
    }
}
