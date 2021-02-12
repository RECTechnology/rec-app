import 'package:flutter/cupertino.dart';
import 'package:rec/Animations/SpinKit.dart';
import 'package:rec/Components/ButtonRec.dart';

//soy incapaz de meter la animacion dentro de el boton


class LoadingButton extends StatefulWidget {
  final String text;
  final Function() onPressed;
  final bool isLoading;

  LoadingButton({

    this.text = 'Empty',
    this.onPressed,
    this.isLoading,
  });

  @override
  State<StatefulWidget> createState() {
    return LoadingButtonState();
  }
}

class LoadingButtonState extends State<LoadingButton> {



  @override
  Widget build(BuildContext context) {

    ButtonRec buttonRec = ButtonRec(onPressed: widget.onPressed,text: widget.text,);

    var containerNotLoading = Container(
      child: Row(
        children: [
          ButtonRec(onPressed: widget.onPressed,text: widget.text,)
        ],
      ),
    );

    var containerLoading =Container(
      height: 50,
      width: 300,
      child: Row(

        children: [
          Container(
            height: 120,
            width: 120,
            child: SpinKit(size: 50,),

          )  ,
         buttonRec


         // buttonRec,



        ],
      ),
    );
    return widget.isLoading? containerLoading : containerNotLoading;
  }

}

/*class LoadingButton extends ButtonRec{

}*/