# kipu-bank

El contrato KipuBank_V1 emula el funcionamiento de un banco donde muchos usuarios pueden 
enviar ETH al contrato y el contrato conservara esos ETH para que los usuarios lo puedan retirar cuando quieran.

Despliegue
1)Para desplegar el contrato, desde Remix IDE, simplemente debe compilarlo con una version de compilador 
compatible. 
2)Luego, debe ir a la ventana de "Deploy & run transactions" y usar Sepolia ETH desde Metamask para 
desplegarlo. 
3)Por ultimo, debe especificar que bankCap (limite de ETH que puede holdear el contrato) y que limite
de maximo retiro establecera para que funcione el contrato.

Interaccion
Para interactuar con el contrato, puede hacer lo siguiente: 
Para depositar, puede mandarle ETH directamente al contrato.
Para retirar, utilizar la funcion retirar() especificando el valor a retirar
Para consultar su saldo, simplemente utiliza la funcion obtenerSaldo()