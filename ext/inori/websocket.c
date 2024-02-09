#include <ruby.h>
#include <ruby/encoding.h>

VALUE Inori = Qnil;
VALUE InoriException = Qnil;
VALUE InoriWebSocket = Qnil;

VALUE ContinousFrameException = Qnil;
VALUE OpCodeException = Qnil;
VALUE NotMaskedException = Qnil;

void Init_inori_ext();
VALUE method_inori_websocket_decode(VALUE self, VALUE data);

void Init_inori_ext()
{
  Inori = rb_define_module("Inori");
  InoriWebSocket = rb_define_class_under(Inori, "WebSocket", rb_cObject);
  InoriException = rb_define_module_under(Inori, "Exception");
  ContinousFrameException = rb_const_get(InoriException, rb_intern("ContinuousFrame"));
  OpCodeException = rb_const_get(InoriException, rb_intern("OpCodeError"));
  NotMaskedException = rb_const_get(InoriException, rb_intern("NotMasked"));
  rb_define_method(InoriWebSocket, "decode", method_inori_websocket_decode, 1);
}

VALUE method_inori_websocket_decode(VALUE self, VALUE data)
{
  int byte, opcode, i, n, fin;
  char *result;
  int *mask_array;
  ID getbyte = rb_intern("getbyte");
  ID close = rb_intern("close");

  byte = NUM2INT(rb_funcall(data, getbyte, 0));
  fin = byte & 0x80;
  opcode = byte & 0x0f;

  if (fin != 0x80)
    rb_raise(ContinousFrameException, "Continous Frame hasn't been implemented yet");

  rb_iv_set(self, "@opcode", INT2NUM(opcode));
  if (opcode != 0x1 && opcode != 0x2 && opcode != 0x8 && opcode != 0x9 && opcode != 0xA)
    rb_raise(OpCodeException, "OpCode %d not supported", opcode);

  if (opcode == 0x8)
  {
    rb_funcall(self, close, 0);
  }

  byte = NUM2INT(rb_funcall(data, getbyte, 0));
  if ((byte & 0x80) != 0x80)
  {
    rb_raise(NotMaskedException, "Messages from client MUST be masked");
  }

  n = byte & 0x7f;
  result = (char *)xmalloc(n);
  mask_array = (int *)xmalloc(4);

  for (i = 0; i < 4; i++) {
    mask_array[i] = NUM2INT(rb_funcall(data, getbyte, 0));
  }

  for (i = 0; i < n; i++)
  {
    result[i] = NUM2INT(rb_funcall(data, getbyte, 0)) ^ mask_array[i % 4];
  }

  if (opcode == 0x1 || opcode == 0x9 || opcode == 0xA)
  {
    rb_iv_set(self, "@msg", rb_enc_str_new(result, n, rb_utf8_encoding()));
  }
  else
  {
    VALUE result_arr = rb_ary_new2(n);
    for (i = 0; i < n; i++)
    {
      rb_ary_store(result_arr, i, INT2NUM(result[i]));
    }
    rb_iv_set(self, "@msg", result_arr);
  }

  xfree(mask_array);
  xfree(result);
  return Qnil;
}
